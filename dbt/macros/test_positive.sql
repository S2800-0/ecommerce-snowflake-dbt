-- Generic test: every value in the column must be greater than zero.
{% test positive(model, column_name) %}
select {{ column_name }} from {{ model }} where {{ column_name }} <= 0
{% endtest %}
