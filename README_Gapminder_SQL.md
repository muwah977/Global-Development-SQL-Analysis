# 🌍 Global Development Analysis (1952–2007) — SQL Project

**Author:** Muwahid Munshi  
**Dataset:** Gapminder Foundation — [gapminder.org](https://www.gapminder.org)   
**Records:** 1,704 rows | 142 countries | 5 continents | 55 years of data

---

## 📌 Project Overview

The **Gapminder dataset**, made famous by statistician Hans Rosling, tracks key human development indicators — GDP per capita, life expectancy, and population — across 142 countries from 1952 to 2007.

In this project I step into the role of a **Data Analyst** to answer real-world questions that economists, policymakers, and business strategists ask every day — using SQL as the primary analytical tool.

> *"The world is not divided into two. It's not rich and poor countries. The world is a continuum."* — Hans Rosling

---

## 🎯 Business Questions Answered

| # | Business Question | SQL Concept |
|---|---|---|
| 1 | How does each continent compare in GDP, life expectancy, and population? | GROUP BY, AVG, SUM |
| 2 | Which are the wealthiest and poorest countries in 2007? | ORDER BY, LIMIT |
| 3 | Which economies grew the fastest over 55 years? | Self JOIN, % growth calculation |
| 4 | How has India's GDP grown year-on-year? | LAG() window function |
| 5 | Which countries have HIGH GDP but LOW life expectancy — the inequality flag? | Multi-condition WHERE |
| 6 | Which countries perform above their continental average? | CTE + JOIN |
| 7 | How do we classify countries into development tiers? | NTILE() window function |
| 8 | Did any countries' life expectancy actually DECLINE? | Self JOIN, conditional filter |
| 9 | What is the running total of population growth per continent? | SUM() OVER() window function |
| 10 | Which countries hit the "development sweet spot"? | Multi-condition filtering |

---

## 📁 Repository Structure

```
gapminder-sql-analysis/
│
├── gapminder.csv                  # Real dataset — 1,704 rows from Gapminder Foundation
├── Gapminder_SQL_Analysis.sql     # Complete SQL project — 7 sections, 25+ queries
└── README.md                      # This file
```

---

## 🗂️ Dataset Description

| Column | Description |
|---|---|
| `country` | Country name (142 unique countries) |
| `continent` | Continent (Africa, Americas, Asia, Europe, Oceania) |
| `year` | Year of observation (1952–2007, every 5 years) |
| `lifeExp` | Life expectancy at birth (years) |
| `pop` | Total population |
| `gdpPercap` | GDP per capita (USD, inflation-adjusted to 2000 dollars) |
| `iso_alpha` | 3-letter ISO country code |
| `iso_num` | Numeric ISO country code |

**Dataset Source:** Gapminder Foundation (gapminder.org) — freely available for educational and research use. Also available via the `plotly.express` Python library.

---

## 🔑 Key Findings

### 1. Global Life Expectancy Rose 18 Years in 55 Years
From 49.1 years (1952) to 67.0 years (2007) — one of the greatest achievements in human history. Asia showed the most dramatic improvement, with Oman gaining 38 years.

### 2. The Asian Tiger Miracle
South Korea (+2,166%), Taiwan (+2,279%), and Singapore (+1,936%) grew their GDP per capita by over 20x in 55 years — the fastest economic development in recorded history.

### 3. Africa's 8x GDP Gap vs Europe
Africa's average GDP per capita ($3,089) is 8x lower than Europe ($25,054) in 2007. Despite having 52 countries and 930 million people, the continent underperforms on every human development metric.

### 4. HIV/AIDS Reversed Life Expectancy in Africa
8 countries show life expectancy LOWER in 2007 than in 1952 — all in Sub-Saharan Africa. Zimbabwe fell from 48.5 to 43.5 years. This is a data-visible public health crisis.

### 5. India's Post-Liberalisation Acceleration
India's GDP growth was 3–8% per period before 1992. Post-liberalisation, growth accelerated significantly — visible directly in the SQL LAG() analysis.

### 6. GDP ≠ Human Development
Equatorial Guinea had a GDP per capita of $12,154 in 2007 (oil-driven) — yet life expectancy was only 51.6 years. Oil wealth concentrated among elites, not distributed to the population.

---

## 💡 Business Recommendations

| For | Insight |
|---|---|
| **International Aid Agencies** | Target the 8 African countries with declining life expectancy — HIV/AIDS intervention is urgent |
| **Investment Strategy** | Asia's fastest-growing economies suggest continued opportunities in S.Korea, Singapore, India |
| **Policy Makers** | Countries with high GDP but low life expectancy need social spending, not just economic growth |
| **Development Banks** | Only 36% of countries outperform their continental average — 64% need structural support |

---

## 🛠️ How to Run

**SQLite (Recommended — Free, No Setup)**
```bash
sqlite3 gapminder.db
.mode csv
.import gapminder.csv gapminder
.read Gapminder_SQL_Analysis.sql
```

**MySQL**
```sql
CREATE DATABASE gapminder_analysis;
USE gapminder_analysis;
-- Import via MySQL Workbench > Data Import Wizard > select gapminder.csv
-- Then run Gapminder_SQL_Analysis.sql
```

**PostgreSQL**
```sql
CREATE TABLE gapminder (country VARCHAR(100), continent VARCHAR(50), year INT, ...);
\COPY gapminder FROM 'gapminder.csv' WITH CSV HEADER;
-- Then run Gapminder_SQL_Analysis.sql
```

---

## 📊 SQL Concepts Demonstrated

| Concept | Where Used |
|---|---|
| `SELECT`, `WHERE`, `ORDER BY`, `GROUP BY` | Throughout |
| Aggregate functions (`SUM`, `AVG`, `MIN`, `MAX`, `COUNT`) | Sections 2–5 |
| Self-JOIN (year-on-year comparison) | GDP growth, life expectancy change |
| `CASE WHEN` (conditional classification) | Development scorecard |
| Subqueries | Population growth analysis |
| **CTE (`WITH` clause)** | Countries above continent average |
| **`RANK()` OVER PARTITION BY** | GDP ranking within continent |
| **`LAG()` OVER PARTITION BY** | India year-on-year GDP growth |
| **`NTILE()`** | Development quartile classification |
| **`SUM() OVER()`** | Running population totals |
| Data quality checks | NULL detection, anomaly validation |
| Business metric derivation | Development index scorecard |

---

## 👤 About Me

**Muwahid Munshi** | MBA in Business Analytics — Lovely Professional University  
Currently based in Bangalore | Available immediately | Open to Data Analyst & Business Analyst roles

📧 muwahidaltaf72@gmail.com  
🔗 [LinkedIn](https://www.linkedin.com/in/muwahid-munshi-1b09081ba)  
💻 [GitHub](https://github.com/muwah977)
