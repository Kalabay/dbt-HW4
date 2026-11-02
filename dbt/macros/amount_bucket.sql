{% macro amount_bucket(column) %}
    case
        when {{ column }} >= {{ var('large_amount') }} then 'LARGE'
        when {{ column }} >= {{ var('medium_amount') }} then 'MEDIUM'
        else 'SMALL'
    end
{% endmacro %}
