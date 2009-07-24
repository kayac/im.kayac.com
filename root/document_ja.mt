<h3>リクエスト</h3>

<p><code>/api/post/{username}</code> に対し下記のようなリクエストを送信することで <code>{username}</code> のアカウントに設定されているIMに対して <code>{message}</code> というメッセージが送信されます。</p>

<p>リクエストの文字コードは <code>utf-8</code> です。</p>

<pre><code>POST /api/post/{username} HTTP/1.0
Content-Type: application/x-www-form-urlencoded
Content-Length: 22

message={message}
</code></pre>

<p>ユーザーがIMの認証設定をしていた場合は追加のパラメータが必要になります。詳しくは認証リクエストの項目を参照してください。</p>

<h3>レスポンス</h3>

<p>レスポンスは以下のようなJSON形式で返ります。</p>

<pre><code>{
  "id": null,
  "error", "",
  "result", "posted"
}
</code></pre>

<p>レスポンス項目:</p>

<ul>
  <li><em>id</em><br />
  リクエストパラメータにidパラメータがあった場合、そのidと同じものが返ります。リクエストにidパラメータがない場合はnullを返します。</li>
  <li><em>error</em><br />
  エラーが発生した場合、エラーの内容が入ります。エラーが発生しなかった場合は空文字列になります。</li>
  <li><em>result</em><br />正常終了した場合 "posted" が入ります。エラーが発生した場合は空文字列になります。</li>
</ul>

<h3>認証リクエスト</h3>

<h4>パスワード認証</h4>

<p>パラメータに password をつけるリクエストです。</p>

<pre><code>POST /api/post/{username} HTTP/1.0
Content-Type: application/x-www-form-urlencoded
Content-Length: 37

message={message}&amp;password={password}
</code></pre>

<h4>秘密鍵認証</h4>

<p>送信する {message} と秘密鍵 {secret} を連結した文字列を SHA-1 ハッシュ化したものを sig パラメータとして送信するリクエストです。</p>

<pre><code>POST /api/post/{username} HTTP/1.0
Content-Type: application/x-www-form-urlencoded
Content-Length: 33

message={message}&amp;sig={secret}
</code></pre>

