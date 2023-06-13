{% macro get_first_name(column_name) %}
    left({{ column_name }}, charindex(' ', {{ column_name }}))
{% endmacro %}