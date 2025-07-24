# 🏊‍♂️🚴‍♂️🏃‍♂️ IRONMAN 70.3 Race Data (2004–2020)

This project explores a clean and comprehensive dataset of IRONMAN 70.3 triathlon race results between 2004 and 2020. It includes participant performance data across swim, transition, bike, and run stages for races held around the world.

## 📁 Dataset Overview

- **Source**: [Kaggle - IRONMAN 70.3 Race Data](https://www.kaggle.com/datasets/aiaiaidavid/ironman-703-race-data-between-2004-and-2020)
- **Rows**: All recorded events from 2004 to 2020
- **Columns**: 13
- **No missing data**

### 🔨 Structure

The dataset includes the following fields:

- `gender`
- `country_of_origin`
- `year`
- `swim_time` (in seconds)
- `transition1_time` (in seconds)
- `bike_time` (in seconds)
- `transition2_time` (in seconds)
- `run_time` (in seconds)
- `finish_time` (in seconds)
- and other event-related details.

All time-based fields are originally stored in **seconds**.

---

## 🧰 Setup and Data Import

1. Created a **PostgreSQL** database and table schema based on the dataset structure.
2. Encountered issues during import:
   - Initial mismatch between table column names and dataset header.
   - Import failed due to not skipping the header row; resolved by enabling "Skip Header" during import.
3. Renamed columns directly through the table properties window post-import to match desired naming conventions.

---

## 🔍 Querying and Preprocessing

To enhance readability and facilitate further querying:

- Converted all time-related columns from seconds to `HH24:MI:SS` format using `make_interval()` and `TO_CHAR()`.
- Created a **view** (`ironman70_3_view`) to avoid altering the original dataset.
```sql
CREATE VIEW ironman70_3_view AS
SELECT *,
	TO_CHAR(make_interval(secs => swim_time), 'HH24:MI:SS') AS swim_duration,
	TO_CHAR(make_interval(secs => transition1_time), 'HH24:MI:SS') AS transition1_duration,
	TO_CHAR(make_interval(secs => bike_time), 'HH24:MI:SS') AS bike_duration,
	TO_CHAR(make_interval(secs => transition2_time), 'HH24:MI:SS') AS transition2_duration,
	TO_CHAR(make_interval(secs => run_time), 'HH24:MI:SS') AS run_duration,
	TO_CHAR(make_interval(secs => finish_time), 'HH24:MI:SS') AS total_time,
	RANK() OVER(PARTITION BY location_ ORDER By finish_time) As ranking,
	TO_CHAR(make_interval(secs => AVG(finish_time) OVER(PARTITION BY gender, age_band, location_)), 'HH24:MI:SS') AS avg_finish_time
FROM ironman70_3;
