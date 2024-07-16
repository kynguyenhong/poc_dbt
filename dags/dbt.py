import os
from datetime import datetime
from pathlib import Path

from cosmos import DbtTaskGroup, DbtDag, ProjectConfig, ProfileConfig
from cosmos.profiles import AthenaAccessKeyProfileMapping 
from airflow import DAG


DEFAULT_DBT_ROOT_PATH = Path(__file__).parent / "dbt"
DBT_ROOT_PATH = Path(os.getenv("DBT_ROOT_PATH", DEFAULT_DBT_ROOT_PATH))



profile_config = ProfileConfig(
    profile_name="finx_athena",
    target_name="dev",
    profiles_yml_filepath="/opt/dbt/profiles.yml"   
)


with DAG(
    dag_id="finx_poc",
    default_args={"retries": 2},
    schedule_interval="@daily",
    start_date=datetime(2024, 1, 1),
    catchup=False,
) as dag:
    basic_cosmos_dag = DbtTaskGroup(
        group_id="poc_group",
        project_config=ProjectConfig(
            DBT_ROOT_PATH
        ),
        profile_config=profile_config,
        operator_args={
            "install_deps": True,  # install any necessary dependencies before running any dbt command
            "full_refresh": True,  # used only in dbt commands that support this flag
        },
        default_args={"retries": 2},
        dag=dag,
    )

