# **Retail & Marketing Analytics for Customer Segmentation**
End‑to‑end analysis of a fashion e‑commerce brand (ShopEasy) using transactional data, campaigns, and customer behavior to understand who our most valuable customers are, how healthy they are, and how marketing campaigns and discounts impact sales and revenue.


## Table of Contents

1. [Dataset Information](#dataset-information)
2. [Objectives / Questions Addressed](#objectives--questions-addressed)
3. [Tools & Technologies Used](#tools--technologies-used)
4. [Project Structure / File Organization](#project-structure--file-organization)
5. [Key Findings / Insights](#key-findings--insights)
6. [Installation & Setup Instructions](#installation--setup-instructions)
7. [How to Use / Reproduce](#how-to-use--reproduce)
8. [Conclusions & Recommendations](#conclusions--recommendations)
9. [Future Work / Improvements](#future-work--improvements)
10. [Author / Contact Information](#author--contact-information) 



---

## Dataset Information


**Files (in `Datasets/`)**

- `dataset_fashion_store_campaigns.csv` – Campaign metadata (name, channel, dates, discount details).  
- `dataset_fashion_store_channels.csv` – Sales channels (App, Web, etc.).  
- `dataset_fashion_store_customers.csv` – Customer demographics and IDs.  
- `dataset_fashion_store_products.csv` – Product catalog and categories (T‑shirts, Dresses, Shoes, etc.).  
- `dataset_fashion_store_sales.csv` – Transaction‑level sales records.  
- `dataset_fashion_store_salesitems.csv` – Line‑item details (product, quantity, discounts).  
- `dataset_fashion_store_stock.csv` – Stock information.


**High‑level data dictionary**

- Customers: `customer_id`, country, RFM segment, category (Active, Risky, Churned).  
- Sales: `sale_id`, `customer_id`, `sale_date`, `channel`, `total_amount`.  
- Sales Items: `sale_id`, `product_id`, quantity, `discounted`, `discount_percent`.  
- Campaigns: `campaign_id`, `campaign_name`, `channel`, `start_date`, `end_date`, `discount_type`, `discount_value`.  
- Products: `product_id`, `category`, price.  

**Usage / Licensing**

- Intended for educational, practice, and portfolio use.

---

## Objectives / Questions Addressed

This project focuses on answering clear business questions, such as:

- Who are our **High_value** and **Medium** customers, and how healthy are they (Active vs At‑risk)?  
- How did sales on **campaign days** compare to **normal days** in April, May, and June?  
- Which **countries** are generating most revenue, and where are High_value customers concentrated ?  
- Which **channels** and **product categories** are most important for High_value and Medium customers?  
- How can we make **marketing spend more efficient** across campaigns, discounts, segments, and countries?

---

## Tools & Technologies Used

- **Languages**
  - SQL (all core analysis and logic)

- **Databases**
  - Any relational database (e.g., PostgreSQL, MySQL) to host the CSV tables.

- **Environment / IDE**
  - VS Code / SQL client (DBeaver, pgAdmin, MySQL Workbench, etc.).  
  - PowerPoint for creating the final business presentation.

- **Version Control**
  - Git & GitHub for project tracking and portfolio.

---

## Project Structure / File Organization

```text
Retail_and_Marketing_For_CustomerSegmentation/
├── Datasets/
│   ├── dataset_fashion_store_campaigns.csv
│   ├── dataset_fashion_store_channels.csv
│   ├── dataset_fashion_store_customers.csv
│   ├── dataset_fashion_store_products.csv
│   ├── dataset_fashion_store_sales.csv
│   ├── dataset_fashion_store_salesitems.csv
│   └── dataset_fashion_store_stock.csv
├── Docs/
│   └── Retail & Marketing for Customer Segmentation (1).pptx
├── scripts/
│   ├── EDA.sql
│   ├── Customer_loyality.sql
│   ├── Increase_Monthly_Revenue.sql
│   └── optimize_digital_marketing.sql
├── README.md
└── (optional) requirements.txt
```

----

## Key Findings / Insights

- Medium customers show growth potential if engaged with campaigns
- Campaigns with 30% discounts generated 25% higher sales uplift than 10% discounts
- Ecommerce and Mobile App contribute most to revenue
- Top-selling categories: T-shirts, Dresses, Shoes
- Revenue is concentrated in France and Germany

----

## Installation & Setup Instructions

```bash
# Clone the repository
git clone https://github.com/Samianadeem2005/Retail-Marketing-CustomerSegmentation.git

# Navigate to directory
cd Retail-Marketing-CustomerSegmentation
```
---

## How to Use / Reproduce

1. Navigate to `scripts/` folder and open SQL notebooks
2. Run `EDA.sql` first to explore sales and customer data
3. Run `Customer_loyality.sql` to segment customers
4. Run `Increase_Monthly_Revenue.sql` and `optimize_digital_marketing.sql` for campaign insights

---

## Conclusions & Recommendations

- High_value customers drive most revenue; focus marketing on retention
- Medium customers are growth potential; use targeted campaigns
- Optimize marketing spend by focusing on top channels and high-performing campaigns
- **Limitations:** Only historical data; results may change with new campaigns
- 
---

## Future Work / Improvements

- Apply machine learning models to predict customer churn
- Add seasonality and trend forecasting to campaigns
- Expand dashboards to include interactive customer segmentation filters

  ----

## Author / Contact Information

- Samia Nadeem
- [Linkedin](https://www.linkedin.com/in/samianadeem1611/)
- [samianadeem247@gmail.com](mailto:samianadeem247@gmail.com)


