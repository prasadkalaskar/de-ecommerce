from common.spark_utils import get_spark_session
from pyspark.sql.functions import col, to_date, date_format
import os


def run_silver_orders():
    spark = get_spark_session("Silver - Orders")

    # 📥 Load from Bronze Delta table
    bronze_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "../data/bronze/orders"))
    df = spark.read.format("delta").load(bronze_path)

    # 🔄 Transformations
    df_transformed = (
        df
        .withColumn("OrderDate", to_date(col("OrderDate")))
        .withColumn("OrderMonth", date_format(col("OrderDate"), "yyyy-MM"))
        # Optional: handle casing, trimming, etc. here
    )

    # 💾 Save to Silver Delta
    silver_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "../data/silver/orders"))
    df_transformed.write.format("delta").mode("overwrite").save(silver_path)

    print(f"✅ Silver Orders written to: {silver_path}")


if __name__ == "__main__":
    run_silver_orders()
