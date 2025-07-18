{% macro change_date(column) %}
    to_date({{column}},'DD/MM/YYYY')
{% endmacro %}