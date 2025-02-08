

WITH source AS (
    SELECT *
    FROM `purwadika`.`rizky_dwh_hailing_facts`.`production_hailing_staging_customer`
)

SELECT *
FROM source

    WHERE created_at > (
        SELECT MAX(created_at)
        FROM `purwadika`.`rizky_dwh_hailing_source`.`dim_customer`
    )
