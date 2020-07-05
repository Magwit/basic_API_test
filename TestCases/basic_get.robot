*** Settings ***
# Library        Requests
Library        RequestsLibrary
Library        Collections
Library        JSONLibrary
Library        os

Resource       ../resources.robot

*** Variables ***
${base_url}    https://calendarific.com/api/v2
${country}     se
${year}        2020
${month}       6


*** Test Cases ***
Get_holiday_info

    ${params}=                Create Dictionary        api_key=${api_key}         country=${country}                          year=${year}        month=${month}
    Create Session            mysession                ${base_url}

    ${response}=              Get Request              mysession                  /holidays                                   params=${params}


    # log to console  ${response.status_code}
    # Log To Console            ${response.content}
    # log to console  ${response.headers}

    # Assertions

    # Should Be Equal As Strings  ${response.status_code}  200 # This works but SDET has another alternative below

    ${status_code}=           Convert To String        ${response.status_code}
    Should Be Equal           ${status_code}           200

    # The header is a python dictionary. Collections Library to the rescue
    ${contentTypeValue}=      Get From Dictionary      ${response.headers}        Content-Type
    Should Be Equal           ${contentTypeValue}      application/json

    # Need to convert the json response body to string
    ${response_body}=         Convert To String        ${response.content}
    Should Contain            ${response_body}         Midsummer

    # More precision inthe assertions concerning the response content as json
    # ${day_path}=              $.response.holidays[3].date.datetime.day
    ${json_object}=           To Json                  ${response.content}
    ${midsummer_day_date}=    Get Value From Json      ${json_object}             $.response.holidays[3].date.datetime.day
    Log To Console            ${midsummer_day_date}