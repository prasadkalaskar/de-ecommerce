from common.spark_utils import get_spark_session
from pyspark.sql.functions import date_format
import os


def run_ingestion():
    spark = get_spark_session("Bronze - Ingest Orders")

    source_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "../data/rawzone/2025/01/orders.csv"))
    output_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "../data/bronze/orders"))

    df = spark.read.option("header", True).csv(source_path)
    df = df.withColumn("OrderMonth", date_format("OrderDate", "yyyy-MM"))
    df.write.format("delta").mode("overwrite").save(output_path)

    print(f"Orders ingested and saved to Delta at: {output_path}")


if __name__ == "__main__":
    run_ingestion()
