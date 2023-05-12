

# API assumptions:

# tests in this file access the API, so are turned off

# offset and length, if unset, are assumed 0 and 5000 by API
# if no sort order is specified, then returned data order is arbitrary
# asking for sort on a metadata request does not error
# setting sort order of period/descending never errors
# currently most query parameters (other than offset and length) ignored by the compatibility endpoint for EIA API v1

