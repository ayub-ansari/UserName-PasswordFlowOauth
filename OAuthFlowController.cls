public class OAuthFlowController{
    
    public static Token getTokenByUsernamePW(){
        AppCredential__mdt cred = AppCredential__mdt.getInstance('TokenDetail');
        String username = EncodingUtil.urlEncode(cred.Username__c, 'UTF-8');
        String password = EncodingUtil.urlEncode(cred.Password__c, 'UTF-8');
        String cid = EncodingUtil.urlEncode(cred.Client_Id__c, 'UTF-8');
        String cis = EncodingUtil.urlEncode(cred.Client_Secret__c, 'UTF-8');
        String scope = EncodingUtil.urlEncode(cred.Scope__c, 'UTF-8');
        String pl = 'grant_type=password'+
                    '&client_id='+cid+'&client_secret='+cis+
                    '&username='+username+'&password='+password+'&scope='+scope;
        System.debug(pl);
        Blob headerValue = Blob.valueOf(cid+':'+cis);
        String authorizationHeader = 'BASIC ' +EncodingUtil.base64Encode(headerValue);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(cred.TokenEndpoint__c);
        req.setMethod('POST');
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody(pl);
        Http http = new Http();
        HTTPResponse res;
        if(!Test.isRunningTest()) res = http.send(req);
        else{ res = new HTTPResponse(); res.setBody('{"expires_in":246, "refresh_token":"abcde","access_token":"abcde"}');}
        System.debug(res.getBody());
        Token at = (Token)JSON.deserialize(res.getBody(), Token.class);
        system.debug(at.access_token);
        system.debug(at.refresh_token);
        accesstoken = at.access_token;   
        return at;  
    }
