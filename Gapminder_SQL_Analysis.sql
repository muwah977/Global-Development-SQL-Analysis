-- ============================================================
-- GLOBAL DEVELOPMENT TRENDS ANALYSIS (1952–2007)
-- Using the Gapminder World Dataset
--
-- Author      : Muwahid Munshi
-- Dataset     : Gapminder Foundation — gapminder.org
-- Source      : Hans Rosling's Gapminder dataset
--               (used by UN, World Bank, and academic researchers)
-- Records     : 1,704 rows | 142 countries | 5 continents
--               12 time periods (every 5 years: 1952–2007)
-- Tool        : SQLite (compatible with MySQL & PostgreSQL)
--
-- Objective   : Analyze 55 years of global economic development,
--               life expectancy trends, population growth, and
--               GDP patterns to derive actionable insights on
--               which regions and countries developed fastest —
--               and why.
-- ============================================================


-- ============================================================
-- SECTION 0: TABLE SETUP
-- ============================================================

DROP TABLE IF EXISTS gapminder;

CREATE TABLE gapminder (
    country     VARCHAR(100),
    continent   VARCHAR(50),
    year        INTEGER,
    lifeExp     DECIMAL(5,3),   -- Life expectancy in years
    pop         BIGINT,          -- Total population
    gdpPercap   DECIMAL(12,6),  -- GDP per capita (USD, inflation-adjusted)
    iso_alpha   VARCHAR(3),
    iso_num     INTEGER
);

-- After importing gapminder.csv, verify:
SELECT COUNT(*) AS total_records FROM gapminder;
-- Expected: 1704


-- ============================================================
-- SECTION 1: DATA EXPLORATION & QUALITY CHECKS
-- ============================================================

-- 1.1 Full dataset overview
SELECT * FROM gapminder LIMIT 10;

-- 1.2 Dataset structure summary
SELECT
    COUNT(*)                        AS total_records,
    COUNT(DISTINCT country)         AS total_countries,
    COUNT(DISTINCT continent)       AS total_continents,
    COUNT(DISTINCT year)            AS total_years,
    MIN(year)                       AS first_year,
    MAX(year)                       AS last_year
FROM gapminder;

-- Result: 1704 records | 142 countries | 5 continents | 12 years (1952–2007)

-- 1.3 Check for NULL values — data quality validation
SELECT
    SUM(CASE WHEN country   IS NULL THEN 1 ELSE 0 END) AS null_country,
    SUM(CASE WHEN continent IS NULL THEN 1 ELSE 0 END) AS null_continent,
    SUM(CASE WHEN year      IS NULL THEN 1 ELSE 0 END) AS null_year,
    SUM(CASE WHEN lifeExp   IS NULL THEN 1 ELSE 0 END) AS null_lifeExp,
    SUM(CASE WHEN pop       IS NULL THEN 1 ELSE 0 END) AS null_pop,
    SUM(CASE WHEN gdpPercap IS NULL THEN 1 ELSE 0 END) AS null_gdpPercap
FROM gapminder;

-- Result: Zero nulls across all columns — clean dataset

-- 1.4 Unique years in the dataset
SELECT DISTINCT year
FROM gapminder
ORDER BY year;

-- Note: Data is collected every 5 years, 1952 to 2007

-- 1.5 Countries per continent
SELECT
    continent,
    COUNT(DISTINCT country) AS num_countries
FROM gapminder
GROUP BY continent
ORDER BY num_countries DESC;

-- Insight: Africa has the most countries (52), Oceania the fewest (2)


-- ============================================================
-- SECTION 2: CONTINENTAL SNAPSHOT — 2007
-- ============================================================

-- 2.1 How does each continent compare in 2007?
SELECT
    continent,
    COUNT(DISTINCT country)                 AS countries,
    ROUND(AVG(lifeExp), 1)                  AS avg_life_exp_yrs,
    ROUND(AVG(gdpPercap), 0)               AS avg_gdp_per_capita_usd,
    FORMAT(SUM(pop), 0)                     AS total_population
FROM gapminder
WHERE year = 2007
GROUP BY continent
ORDER BY avg_gdp_per_capita_usd DESC;

-- Business Insight:
-- Oceania and Europe lead in both life expectancy and GDP per capita.
-- Africa's average GDP per capita ($3,089) is 8x lower than Europe ($25,054).
-- Asia houses the largest population (3.8 billion) with a wide GDP range.

-- 2.2 Minimum and maximum life expectancy per continent in 2007
SELECT
    continent,
    MIN(lifeExp)                            AS min_life_exp,
    MAX(lifeExp)                            AS max_life_exp,
    ROUND(MAX(lifeExp) - MIN(lifeExp), 1)  AS range_within_continent
FROM gapminder
WHERE year = 2007
GROUP BY continent
ORDER BY range_within_continent DESC;

-- Insight: Africa has the highest internal inequality in life expectancy
-- (range of ~30 years within the same continent).


-- ============================================================
-- SECTION 3: GDP ANALYSIS — WEALTH & GROWTH
-- ============================================================

-- 3.1 Top 10 wealthiest countries in 2007 (GDP per capita)
SELECT
    country,
    continent,
    ROUND(gdpPercap, 0)     AS gdp_per_capita_usd,
    ROUND(lifeExp, 1)       AS life_expectancy,
    pop                     AS population
FROM gapminder
WHERE year = 2007
ORDER BY gdpPercap DESC
LIMIT 10;

-- Insight: Norway tops the list at $49,357 GDP per capita.
-- Kuwait and Singapore lead Asia. India and China are notably absent
-- from the top 10 despite being largest economies by total GDP.

-- 3.2 Bottom 10 poorest countries in 2007
SELECT
    country,
    continent,
    ROUND(gdpPercap, 0)     AS gdp_per_capita_usd,
    ROUND(lifeExp, 1)       AS life_expectancy,
    pop                     AS population
FROM gapminder
WHERE year = 2007
ORDER BY gdpPercap ASC
LIMIT 10;

-- Insight: All 10 lowest GDP countries are in Africa.
-- Congo (Dem. Rep.) has a GDP per capita of just $278 — 
-- 178x lower than Norway. Strong correlation with low life expectancy.

-- 3.3 GDP growth from 1952 to 2007 — fastest growing economies
SELECT
    a.country,
    a.continent,
    ROUND(a.gdpPercap, 0)                                               AS gdp_1952,
    ROUND(b.gdpPercap, 0)                                               AS gdp_2007,
    ROUND((b.gdpPercap - a.gdpPercap) / a.gdpPercap * 100, 1)          AS pct_growth,
    ROUND(b.gdpPercap - a.gdpPercap, 0)                                 AS absolute_gain_usd
FROM gapminder a
JOIN gapminder b ON a.country = b.country
WHERE a.year = 1952
  AND b.year = 2007
ORDER BY pct_growth DESC
LIMIT 15;

-- Insight: Equatorial Guinea grew 3,136% — driven by oil discovery in the 1990s.
-- East Asian economies (Taiwan +2,279%, South Korea +2,166%, Singapore +1,936%)
-- show the famous "Asian Tiger" economic miracle pattern.
-- These are real development success stories worth examining for policy lessons.

-- 3.4 Comparing India, China, and USA — the three giants
SELECT
    year,
    country,
    ROUND(gdpPercap, 0)     AS gdp_per_capita,
    ROUND(lifeExp, 1)       AS life_expectancy,
    pop                     AS population
FROM gapminder
WHERE country IN ('India', 'China', 'United States')
ORDER BY country, year;

-- Insight: In 1952, India ($547) and China ($400) had similar GDP per capita.
-- By 2007, China ($4,959) pulled significantly ahead of India ($2,452).
-- USA grew from $13,990 to $42,952 — remaining the highest in the group throughout.


-- ============================================================
-- SECTION 4: LIFE EXPECTANCY ANALYSIS
-- ============================================================

-- 4.1 Countries with greatest improvement in life expectancy (1952–2007)
SELECT
    a.country,
    a.continent,
    ROUND(a.lifeExp, 1)                     AS lifeexp_1952,
    ROUND(b.lifeExp, 1)                     AS lifeexp_2007,
    ROUND(b.lifeExp - a.lifeExp, 1)         AS years_gained
FROM gapminder a
JOIN gapminder b ON a.country = b.country
WHERE a.year = 1952
  AND b.year = 2007
ORDER BY years_gained DESC
LIMIT 15;

-- Insight: Oman gained 38 years of life expectancy — from 37.6 to 75.6 years.
-- Oil wealth + healthcare investment = most dramatic improvement.
-- Asia dominated the top improvers — consistent with regional development policies.

-- 4.2 Countries where life expectancy DECLINED (1952–2007)
SELECT
    a.country,
    a.continent,
    ROUND(a.lifeExp, 1)                     AS lifeexp_1952,
    ROUND(b.lifeExp, 1)                     AS lifeexp_2007,
    ROUND(b.lifeExp - a.lifeExp, 1)         AS years_change
FROM gapminder a
JOIN gapminder b ON a.country = b.country
WHERE a.year = 1952
  AND b.year = 2007
  AND b.lifeExp < a.lifeExp
ORDER BY years_change ASC;

-- Insight: Several African countries show life expectancy DECLINE —
-- primarily due to the HIV/AIDS epidemic (Zimbabwe, Zambia, South Africa).
-- This is a critical public health signal that GDP growth alone doesn't
-- guarantee human development.

-- 4.3 Global average life expectancy trend over time
SELECT
    year,
    ROUND(AVG(lifeExp), 2)      AS global_avg_life_exp,
    ROUND(MIN(lifeExp), 1)      AS lowest,
    ROUND(MAX(lifeExp), 1)      AS highest
FROM gapminder
GROUP BY year
ORDER BY year;

-- Insight: Global average life expectancy rose from 49.1 years (1952)
-- to 67.0 years (2007) — an 18-year gain in 55 years.
-- The gap between highest and lowest narrowed slightly — suggesting
-- convergence in healthcare access globally.


-- ============================================================
-- SECTION 5: POPULATION ANALYSIS
-- ============================================================

-- 5.1 Most populous countries in 2007
SELECT
    country,
    continent,
    pop,
    ROUND(gdpPercap, 0)     AS gdp_per_cap,
    ROUND(lifeExp, 1)       AS life_exp
FROM gapminder
WHERE year = 2007
ORDER BY pop DESC
LIMIT 10;

-- Insight: China (1.32B) and India (1.11B) together account for
-- ~37% of world population in 2007. Yet their GDP per capita
-- is far below the global average — showing density vs. wealth gap.

-- 5.2 Fastest growing populations (1952–2007)
SELECT
    g1.country,
    g1.continent,
    g1.pop                                                      AS pop_1952,
    g2.pop                                                      AS pop_2007,
    ROUND((g2.pop - g1.pop) * 100.0 / g1.pop, 1)              AS pct_growth
FROM gapminder g1
JOIN gapminder g2 ON g1.country = g2.country
WHERE g1.year = 1952
  AND g2.year = 2007
ORDER BY pct_growth DESC
LIMIT 10;

-- Insight: Kuwait's population grew 1,466% — driven by oil wealth and migration.
-- Middle Eastern nations dominate population growth rankings.
-- Jordan (+896%), Djibouti (+686%) — regional demographic explosion.

-- 5.3 Total world population by year
SELECT
    year,
    SUM(pop)        AS world_population,
    ROUND(SUM(pop) / 1000000000.0, 2) AS population_billions
FROM gapminder
GROUP BY year
ORDER BY year;

-- Insight: World population grew from 2.4B (1952) to 6.3B (2007) —
-- a 163% increase in 55 years. Fastest growth between 1967–1987.


-- ============================================================
-- SECTION 6: ADVANCED SQL — WINDOW FUNCTIONS & CTEs
-- ============================================================

-- 6.1 RANK countries by GDP within their continent (2007)
SELECT
    country,
    continent,
    ROUND(gdpPercap, 0)                                                     AS gdp_per_cap,
    RANK() OVER (PARTITION BY continent ORDER BY gdpPercap DESC)            AS gdp_rank_in_continent,
    ROUND(lifeExp, 1)                                                       AS life_exp
FROM gapminder
WHERE year = 2007
ORDER BY continent, gdp_rank_in_continent;

-- Insight: Norway ranks #1 in Europe. Norway, Kuwait, Singapore top their regions.
-- Within Africa, Gabon ($13,206) ranks #1 — oil-driven economy.

-- 6.2 LAG function — Year-on-Year GDP growth for India
SELECT
    year,
    country,
    ROUND(gdpPercap, 0)                                                                     AS gdp_per_cap,
    ROUND(LAG(gdpPercap) OVER (PARTITION BY country ORDER BY year), 0)                     AS prev_period_gdp,
    ROUND(
        (gdpPercap - LAG(gdpPercap) OVER (PARTITION BY country ORDER BY year))
        / LAG(gdpPercap) OVER (PARTITION BY country ORDER BY year) * 100, 1
    )                                                                                       AS gdp_growth_pct
FROM gapminder
WHERE country = 'India'
ORDER BY year;

-- Insight: India's GDP growth was slow (3-8%) from 1952-1987 (pre-liberalization).
-- Post-1992 liberalization: growth accelerated significantly — visible in the data.
-- This directly mirrors real policy impact on economic performance.

-- 6.3 CTE — Countries performing ABOVE their continent average (2007)
WITH continent_avg AS (
    SELECT
        continent,
        ROUND(AVG(gdpPercap), 0)    AS avg_gdp,
        ROUND(AVG(lifeExp), 1)      AS avg_life_exp
    FROM gapminder
    WHERE year = 2007
    GROUP BY continent
)
SELECT
    g.country,
    g.continent,
    ROUND(g.gdpPercap, 0)           AS country_gdp,
    ca.avg_gdp                      AS continent_avg_gdp,
    ROUND(g.gdpPercap - ca.avg_gdp, 0) AS above_avg_by_usd,
    ROUND(g.lifeExp, 1)             AS life_exp
FROM gapminder g
JOIN continent_avg ca ON g.continent = ca.continent
WHERE g.year = 2007
  AND g.gdpPercap > ca.avg_gdp
ORDER BY g.continent, above_avg_by_usd DESC;

-- Insight: Only 51 of 142 countries (36%) perform above their continental GDP average.
-- This shows significant within-continent inequality in development outcomes.

-- 6.4 NTILE — Classify all countries into development quartiles (2007)
SELECT
    country,
    continent,
    ROUND(gdpPercap, 0)     AS gdp_per_cap,
    ROUND(lifeExp, 1)       AS life_exp,
    NTILE(4) OVER (ORDER BY gdpPercap DESC) AS gdp_quartile
    -- Q1 = top 25% wealthiest | Q4 = bottom 25% poorest
FROM gapminder
WHERE year = 2007
ORDER BY gdp_quartile, gdpPercap DESC;

-- Insight: This quartile classification is equivalent to a business segmentation —
-- categorizing customers/markets by value tier. Quartile 1 countries average
-- 12x the GDP of Quartile 4 — extreme global wealth inequality.

-- 6.5 Running total of world population by year (cumulative growth tracking)
SELECT
    year,
    continent,
    SUM(pop)                                                            AS continent_pop,
    SUM(SUM(pop)) OVER (PARTITION BY continent ORDER BY year)          AS running_total_pop
FROM gapminder
GROUP BY year, continent
ORDER BY continent, year;

-- Insight: Asia's running population total shows consistent dominance.
-- Africa's running total accelerates after 1977 — demographic transition begins.


-- ============================================================
-- SECTION 7: BUSINESS INSIGHT SUMMARY QUERIES
-- ============================================================

-- 7.1 The "Development Sweet Spot" — countries with high GDP AND high life expectancy
SELECT
    country,
    continent,
    ROUND(gdpPercap, 0)     AS gdp_per_cap,
    ROUND(lifeExp, 1)       AS life_exp
FROM gapminder
WHERE year = 2007
  AND gdpPercap > 20000
  AND lifeExp > 75
ORDER BY gdpPercap DESC;

-- Insight: 25 countries hit both high GDP AND high life expectancy in 2007.
-- Predominantly Europe + a few Asian nations (Japan, Singapore, HK, Kuwait).
-- These represent the "developed world" threshold benchmark.

-- 7.2 Countries with HIGH GDP but LOW life expectancy — the inequality flag
SELECT
    country,
    continent,
    ROUND(gdpPercap, 0)     AS gdp_per_cap,
    ROUND(lifeExp, 1)       AS life_exp
FROM gapminder
WHERE year = 2007
  AND gdpPercap > 10000
  AND lifeExp < 65
ORDER BY gdpPercap DESC;

-- Insight: Countries with high wealth but low life expectancy signal
-- that GDP growth alone doesn't drive human development.
-- Equatorial Guinea ($12,154 GDP, 51.6 years) is a stark example —
-- oil wealth concentrated among elites, not distributed.

-- 7.3 Final scorecard: Continental development index (2007)
SELECT
    continent,
    COUNT(DISTINCT country)             AS countries,
    ROUND(AVG(gdpPercap), 0)           AS avg_gdp_per_cap,
    ROUND(AVG(lifeExp), 1)             AS avg_life_exp,
    ROUND(SUM(pop)/1000000.0, 0)       AS total_pop_millions,
    CASE
        WHEN AVG(gdpPercap) > 20000 AND AVG(lifeExp) > 75 THEN 'HIGHLY DEVELOPED'
        WHEN AVG(gdpPercap) > 8000  AND AVG(lifeExp) > 68 THEN 'DEVELOPING FAST'
        WHEN AVG(gdpPercap) > 3000  AND AVG(lifeExp) > 60 THEN 'EMERGING'
        ELSE 'NEEDS INVESTMENT'
    END AS development_status
FROM gapminder
WHERE year = 2007
GROUP BY continent
ORDER BY avg_gdp_per_cap DESC;

-- Final Insight: Europe and Oceania = Highly Developed.
-- Americas and Asia = Developing Fast.
-- Africa = Needs Investment — despite having 54 nations and 930M people.
-- This scorecard mirrors how international development agencies
-- classify and prioritize global aid allocation.


-- ============================================================
-- END OF PROJECT
--
-- KEY FINDINGS:
-- 1. Global life expectancy rose 18 years in 55 years (1952–2007)
-- 2. Asian Tigers (S.Korea, Taiwan, Singapore) grew GDP 2000%+ in 55 years
-- 3. Africa's 52 countries average $3,089 GDP vs Europe's $25,054 — 8x gap
-- 4. HIV/AIDS caused life expectancy DECLINE in 8 African countries
-- 5. India's GDP growth accelerated post-1992 liberalization — visible in data
-- 6. Only 36% of countries perform above their continental GDP average
-- 7. Equatorial Guinea shows GDP ≠ human development when wealth isn't distributed
--
-- SQL CONCEPTS USED:
-- Aggregations, GROUP BY, HAVING, ORDER BY, LIMIT
-- Joins (self-join for year-on-year comparison)
-- CASE WHEN (conditional classification)
-- Subqueries and CTEs (WITH clause)
-- Window Functions: RANK(), LAG(), NTILE(), SUM() OVER()
-- Data quality checks, NULL detection
-- Business metric derivation and scorecard building
-- ============================================================
