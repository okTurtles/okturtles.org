# okturtles.org

This project uses [nginx SSI](http://nginx.org/en/docs/http/ngx_http_ssi_module.html)
to include header and footer files. For local testing it uses the
[node-ssi](https://github.com/yanni4night/node-ssi) module.

To test locally:

1. Install dependencies

   npm install

2. Then run the server using:

   npm run dev

And visit: [http://localhost:8080](http://localhost:8080)

## Development

To compile scss files in `includes/sass` folder, run `npm run compile-sass`

## TODO

- Use a Gruntfile instead of `npm run compile-sass` stuff.
