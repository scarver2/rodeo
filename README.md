# Rodeo
The [Sinatra](https://sinatrarb.com) web application for [Texas Embroidery Ranch](https://www.texasembroideryranch.com).

## Developer Notes

### Prerequisites & Installation
Assuming a working Ruby environment, install the gem dependencies:
```bash
bundle install
```

Add the following to your `/etc/hosts` file:
```bash
echo "127.0.0.1 rodeo.local" >> /etc/hosts
```

### Local Development

* Uses Docker Compose to run a local development environment.

```bash
docker compose -f docker-compose.local.yml up --build
```

### Continuous Integration
Full linting, testing, and browser reloading:
```bash
bundle exec guard
```

### Testing

* Uses RSpec to test the entire application. 
* Uses Capybara to test the web interface.

Run the test suite
```bash
bundle exec rspec
```

### Environment Variables & Secrets
Secrets live in .kamal/secrets and are never committed.

## License
Copyright 2025 Stan Carver II
[Texas Embroidery Ranch](https://www.texasembroideryranch.com) is a property of [Purecreate, llc](purecreate.com)
