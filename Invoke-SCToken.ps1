Function Invoke-SCToken{

<#
        .SYNOPSIS

        Request token from Tenable SC.

        .DESCRIPTION

        This function was created with a purpose of generating token and session value for Tenable SC API

        .PARAMETER Server

        Tenable Security Center server name.

        .PARAMETER Credential

        Credentials that you want to use to connect via API
		
        .INPUTS

        None. You cannot pipe objects to Credential-Manager.

        .OUTPUTS

        An array object is return which contain values for token and session

        .EXAMPLE

        URL and URL query are different depend on what part of Tenable SC you want to access.

        PS> $header = Invoke-SCConnectionToken -Credential $cred -Server $server
        PS> Invoke-WebRequest -Uri $($url+$url_query) -Headers $header.token -UseBasicParsing -WebSession $header.session
   
        .LINK

        API Documentation: https://docs.tenable.com/tenablesc/api/Token.htm

        .NOTES

        Author: Rafał Chrzanowski
        Created : 17 May 2020
        Modified: 05 Feb 2021


    #>


 param(
      [ValidateNotNull()]
      [Parameter(Mandatory=$true)]
      [pscredential]$Credential,
      [ValidateNotNull()]
      [Parameter(Mandatory=$true)]
      [string]$Server
      )

$Username = $Credential.GetNetworkCredential().Username 
$Password = $Credential.GetNetworkCredential().Password 

$RequestParams = @{ "username"="$Username"; "password"= "$Password";} 
$RequestBody = ConvertTo-Json $RequestParams 
$URL = " https://$Server/rest/token " 
$Response = Invoke-WebRequest -URI $URL -Body $RequestBody -ContentType 'application/json' -Method Post -UseBasicParsing -SessionVariable SecurityCenterSession -TimeoutSec 300

$token = (convertfrom-json $Response.Content).response.token 

$return = @{
  "token"= @{"X-SecurityCenter"="$token"};
  "session"= $SecurityCenterSession;
}

$return
}
