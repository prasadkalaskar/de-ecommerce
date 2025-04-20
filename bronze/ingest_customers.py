from common.spark_utils import get_spark_session
import os


def run_ingestion():
    spark = get_spark_session("Bronze - Ingest Customers")

    source_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "../data/rawzone/master/customers.csv"))
    output_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "../data/bronze/customers"))

    df = spark.read.option("header", True).csv(source_path)
    df.write.format("delta").mode("overwrite").save(output_path)

    print(f"Customers ingested and saved to Delta at: {output_path}")


if __name__ == "__main__":
    run_ingestion()
