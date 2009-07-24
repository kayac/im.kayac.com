<h3>Request</h3>

Message should be POSTed to following URL:

    http://im.kayac.com/api/post/{username}

<h4>POST Parameters</h4>

<ul>
  <li><em>message</em><br />
  a text message sending to {username}
  <li><em>password</em> (optional)<br />
  If {username} use password authentication, valid password is required.
  <li><em>secret</em> (optional)<br />
  If {username} use secret authentication, valid secret signature is required.
</ul>

Secret segnature is SHA-1 hex digest of {message}+{secretkey}.

For example, message is "Hello" and secret key is "SecretKey":

<pre><code>sig=3e287020daaa2771e73ceda2e798c2d576882f22  // sha1_hex( "HelloSecretKey" );
</code></pre>

<h3>Response</h3>

Response is a JSON format like below:

<pre><code>{
  "id": null,
  "error", "",
  "result", "posted"
}
</code></pre>

<p>response parameters are:</p>

<ul>
  <li><em>error</em><br />
  Error message string if error is occured.</li>
  <li><em>result</em><br />
  Response message. If request success, "posted" is returned.
  </li>
</ul>
