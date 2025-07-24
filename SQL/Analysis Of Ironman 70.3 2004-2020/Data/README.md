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
  <img width="703" height="347" alt="Screenshot 2025-07-24 at 12 13 24 PM" src="https://github.com/user-attachments/assets/aafb65e0-163c-4a70-8406-3826062a39da" />
