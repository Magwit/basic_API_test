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

    ${status_code}=         Convert To String      ${response.status_code}
    Should Be Equal         ${status_code}         200

    # The header is a python dictionary. Collections Library is used to TK
    ${contentTypeValue}=    Get From Dictionary    ${response.headers}        Content-Type
    Should Be Equal         ${contentTypeValue}    application/json

    # Need to convert the json response body to string
    ${response_body}=       Convert To String      ${response.content}
    Should Contain          ${response_body}       Midsummer Day

