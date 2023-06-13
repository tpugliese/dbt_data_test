{% macro get_zip_5(column_name) %}
    left({{ column_name }}, 5)
{% endmacro %}