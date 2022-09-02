@RestResource(urlMapping='/mockit/*')
global with sharing class MockitResource {

    private class MockitMatch {
        Integer statusCode;
        String responseJson;
    }

    @HttpGet
    global static void getMockit() {
        System.debug('mockit:GET');
        String uri = RestContext.request.requestURI;
        System.debug(uri);
        MockitMatch mockitMatch = MockitResource.findMatch('GET', uri);
        System.debug(mockitMatch);
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.statusCode = mockitMatch.statusCode;
        RestContext.response.responseBody = Blob.valueOf(mockitMatch.responseJson);
    }

    @HttpPost
    global static void postMockit() {
        String uri = RestContext.request.requestURI;
        MockitMatch mockitMatch = MockitResource.findMatch('POST', uri);
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.statusCode = mockitMatch.statusCode;
        RestContext.response.responseBody = Blob.valueOf(mockitMatch.responseJson);
    }

    @HttpPut
    global static void putMockit() {
        String uri = RestContext.request.requestURI;
        MockitMatch mockitMatch = MockitResource.findMatch('PUT', uri);
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.statusCode = mockitMatch.statusCode;
        RestContext.response.responseBody = Blob.valueOf(mockitMatch.responseJson);
    }

    @HttpDelete
    global static void deleteMockit() {
        String uri = RestContext.request.requestURI;
        MockitMatch mockitMatch = MockitResource.findMatch('DELETE', uri);
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.statusCode = mockitMatch.statusCode;
        RestContext.response.responseBody = Blob.valueOf(mockitMatch.responseJson);
    }

    private static MockitMatch findMatch(String method, String uri){
        MockitMatch mockitMatch = new MockitMatch();
        mockitMatch.statusCode=404;
        mockitMatch.responseJson='{"message":"path not found"}';
        String jsonResponse = null;
        try{
            for(mockit__mdt m: [select match__c,id,response__c,status_code__c from mockit__mdt where active__c=true and method__c=:method order by label]){
                Pattern uriPattern = Pattern.compile(m.match__c);
                Matcher uriMatcher = uriPattern.matcher(uri);
                if(uriMatcher.matches()){
                    mockitMatch.statusCode = Integer.valueOf(m.status_code__c);
                    mockitMatch.responseJson = m.response__c;
                    break;
                }
            }
        }
        catch(Exception e){
            System.debug('Unable to locate uri: '+uri+' method: '+method);
            mockitMatch.statusCode = 500;
            mockitMatch.responseJson = '{"message":"exception locating path"}';
        }
        return mockitMatch;
    }

}
