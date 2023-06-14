{% macro get_last_name(column_name) %}
    substring({{ column_name }} , charindex(' ', {{ column_name }} )+1) 
{% endmacro %}
