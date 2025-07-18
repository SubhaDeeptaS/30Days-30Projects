{%macro find_month(month_of_purchase) %}
    case
        when month_of_purchase = 'Jan' then 1
        when month_of_purchase = 'Feb' then 2
        when month_of_purchase = 'Mar' then 3
        when month_of_purchase = 'Apr' then 4
        when month_of_purchase = 'May' then 5
        when month_of_purchase = 'Jun' then 6
        when month_of_purchase = 'Jul' then 7
        when month_of_purchase = 'Aug' then 8
        when month_of_purchase = 'Sep' then 9
        when month_of_purchase = 'Oct' then 10
        when month_of_purchase = 'Nov' then 11
        when month_of_purchase = 'Dec' then 12
    end
{% endmacro %}