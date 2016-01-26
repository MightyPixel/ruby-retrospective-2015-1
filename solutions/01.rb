def convert_to_bgn(amount, currency)
  currencies = {bgn: 1, usd: 1.7408, eur: 1.9557, gbp: 2.6415}

  (amount * currencies[currency]).round(2)
end


def compare_prices(amount, currency, other_amount, other_currency)
  amount_in_bgn = convert_to_bgn(amount, currency)
  other_amount_in_bgn = convert_to_bgn(other_amount, other_currency)

  amount_in_bgn - other_amount_in_bgn
end
