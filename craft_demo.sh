#!/bin/bash

API_ENDPOINT="https://www.travel-advisory.info/api"
DATA_FILE="data.json"

# Fetch data from the API or use the local file
fetch_data() {
    [ -f "$DATA_FILE" ] || curl -s "$API_ENDPOINT" > "$DATA_FILE"
}

# Look up country name by country code
lookup_country() {
    country_name=$(jq -r ".data.\"$1\".name" "$DATA_FILE" 2>/dev/null)
    [ "$country_name" != "null" ] && echo "$country_name"
}

# Handle multiple country codes
lookup_multiple_countries() {
    for country_code in "$@"; do
        country_name=$(lookup_country "$country_code")
        [ -n "$country_name" ] && echo "$country_code: $country_name" || echo "$country_code: Not found"
    done
}

# Fetch data from the API or use the local file
fetch_data

# Example usage: ./country_lookup.sh AU
if [ -n "$1" ] && [ "$1" != "--multiple" ]; then
    lookup_country "$1" || echo "Country code '$1' not found."
elif [ "$1" == "--multiple" ]; then
    shift
    lookup_multiple_countries "$@"
else
     # Prompt for country codes
    printf "Enter country code(s) separated by space: "
    read -r country_codes_input
    country_codes=($country_codes_input)

    lookup_multiple_countries "${country_codes[@]}"
#    echo "Usage: $0 <country_code>"
#    echo "       $0 --multiple <country_code1> <country_code2> ..."
fi
