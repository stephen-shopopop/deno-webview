import { Webview } from "webview";

const html = `
  <html>
  <body>
    <h1>Hello from deno v${Deno.version.deno}</h1>
    <footer>I am hungry</footer>
  </body>
  </html>
`;

const webview = new Webview(Deno.args.includes("debug"));

webview.navigate(`data:text/html,${encodeURIComponent(html)}`);
webview.title = "Broz";
webview.run();
