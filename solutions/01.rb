def convert_to_bgn(amount, currency)
  currencies = {bgn: 1, usd: 1.7408, eur: 1.9557, gbp: 2.6415}

  converted_amount = amount * currencies[currency]
  converted_amount.round(2)
end


def compare_prices(first_amount, first_currency, second_amount, second_currency)
  first_amount_in_bgn = convert_to_bgn(first_amount, first_currency)
  second_amount_in_bgn = convert_to_bgn(second_amount, second_currency)

  first_amount_in_bgn <=> second_amount_in_bgn
end
