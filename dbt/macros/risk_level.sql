{% macro risk_level(column) %}
    case
        when {{ column }} >= {{ var('high_risk') }} then 'HIGH'
        when {{ column }} >= {{ var('medium_risk') }} then 'MEDIUM'
        else 'LOW'
    end
{% endmacro %}
