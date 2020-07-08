*** Settings ***
Library        RequestsLibrary
Library        Collections
Library        JSONLibrary

Resource       ../resources.robot

*** Variables ***
${base_url}    https://calendarific.com/api/v2
${country}     se
${year}        2020
${month}       6


*** Test Cases ***
Get_holiday_info

    ${params}=              Create Dictionary      api_key=${api_key}         country=${country}    year=${year}        month=${month}
    Create Session          mysession              ${base_url}

    ${response}=            Get Request            mysession                  /holidays             params=${params}

    # Assertions

    # Assert successful response to the API call
    ${status_code}=         Convert To String      ${response.status_code}
    Should Be Equal         ${status_code}         200

    # Return the content-type from the response header and assert that it is a json response
    ${contentTypeValue}=    Get From Dictionary    ${response.headers}        Content-Type
    Should Be Equal         ${contentTypeValue}    application/json

    # Convert the json response body to string and assert that Midsummer Day is in the response
    ${response_body}=       Convert To String      ${response.content}
    Should Contain          ${response_body}       Midsummer Day

