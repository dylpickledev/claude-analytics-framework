# Your Data Repositories

Place your actual data repositories here:

```
repos/
├── dbt_cloud/              # Your dbt project
├── data_pipelines/         # ETL/orchestration code
├── tableau_workbooks/      # BI dashboards
└── [your other repos]/     # Any other data repos
```

**Note:** This folder is gitignored - your repos won't be committed to the framework.

## How to Add Repos

```bash
cd repos/
git clone <your-dbt-repo-url> dbt_cloud
git clone <your-pipeline-repo-url> data_pipelines
# etc...
```

Or if you prefer, symlink to existing local repos:
```bash
ln -s ~/projects/dbt-project repos/dbt_cloud
ln -s ~/projects/data-pipelines repos/data_pipelines
```

