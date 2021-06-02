**Authentication**:<br>
 - After login you can retrieve token from headers.<br>
 - To logout token must be deleted on the front-end side only.

**Photo uploading:**<br>
 Linkstagram requires direct photo uploading onto S3 storage. 
 <br> Firstly, to get AWS credentials the following request should be done:
 <br>`GET /s3/params`
 <br> It returns the HTTP verb (POST) and the S3 URL to which the file
  should be uploaded, along with the required POST parameters and request headers.
 <br> Secondly, make a request to this endpoint and use these parameters to upload the
 file directly to S3.<br>
 Once the file has been uploaded, you can generate a JSON representation of the
 uploaded file on the client side. The response will contain id (location of the file on S3),
 storage, metadata which then should be passed to the back-end side to save information about the photo.