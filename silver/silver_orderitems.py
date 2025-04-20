from common.spark_utils import get_spark_session
from pyspark.sql.functions import col, date_format, to_date, expr, round
import os


def run_silver_orderitems():
    spark = get_spark_session("Silver - Order Items")

    # Load from Bronze
    base_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "../data/bronze"))
    df_items = spark.read.format("delta").load(f"{base_path}/orderitems")
    df_orders = spark.read.format("delta").load(f"{base_path}/orders")
    df_products = spark.read.format("delta").load(f"{base_path}/products")
    df_subcategories = spark.read.format("delta").load(f"{base_path}/subcategories")
    df_categories = spark.read.format("delta").load(f"{base_path}/categories")

    # Prep Orders table
    df_orders = df_orders.withColumn("OrderDate", to_date(col("OrderDate")))
    df_orders = df_orders.withColumn("OrderMonth", date_format(col("OrderDate"), "yyyy-MM"))

    # Join Products → Subcategories → Categories
    df_products_full = (
        df_products
        .join(df_subcategories, on="SubCategoryID", how="left")
        .join(df_categories, on="CategoryID", how="left")
    )

    # Join with OrderItems and Orders
    df_enriched = (
        df_items
        .join(df_orders, on="OrderID", how="left")
        .join(df_products_full, on="ProductID", how="left")
        .select(
            "OrderID", "ItemID", "ProductID",
            "Quantity", df_items["Price"].alias("ItemPrice"),
            "OrderDate", "OrderMonth", "CustomerID", "SellingEntityID",
            "ProductName", df_products_full["Price"].alias("ProductPrice"),
            "SubCategoryID", "SubCategoryName", "CategoryID", "CategoryName"
        )
    )

    # PATCH BEGINS HERE
    df_enriched = df_enriched.withColumn("Cost", round(expr("ProductPrice * 0.7"), 2))
    df_enriched = df_enriched.withColumn("ProfitAmount", round(expr("(ItemPrice - Cost) * Quantity"), 2))
    # Write to Silver
    silver_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "../data/silver/orderitems"))
    df_enriched.write.format("delta").mode("overwrite").option("mergeSchema", "true").save(silver_path)

    print(f"[SUCCESS] Silver Order Items written to: {silver_path}")


if __name__ == "__main__":
    run_silver_orderitems()
