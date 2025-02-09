{{
    config(
        materialized='incremental',
        unique_key='driver_id',
            partition_by={
                "field": "created_at",
                "data_type": "timestamp"
            }
    )
}}


WITH driver AS (
    SELECT *
    FROM {{ ref('production_hailing_staging_driver') }} --pakai ref untuk buat dependency

),

vehicle AS (
    SELECT *
    FROM {{ ref('production_hailing_staging_vehicle')}}
)

SELECT
    driver.driver_id,
    vehicle.vehicle_id,
    driver.name as driver_name,
    driver.phone_number as phone_number,
    driver.email as email,
    vehicle.vehicle_type,
    vehicle.brand as vehicle_brand,
    vehicle.year as vehicle_production_year,
    vehicle.license_plate,
    driver.created_at
FROM driver
LEFT JOIN vehicle
on driver.driver_id = vehicle.vehicle_id

{% if check_if_incremental() %}
    WHERE driver.created_at > (
        SELECT MAX(driver.created_at)
        FROM {{ this }}
    )
{% endif %}