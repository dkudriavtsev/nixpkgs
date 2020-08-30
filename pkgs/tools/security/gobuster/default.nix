{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "gobuster";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "OJ";
    repo = "gobuster";
    rev = "v${version}";
    sha256 = "0q8ighqykh8qyvidnm6az6dc9mp32bbmhkmkqzl1ybbw6paa8pym";
  };

  vendorSha256 = "0kr9i2nm5csf3070hwaiss137pfa3088xbw2zigp7aqb2naky036";

  doCheck = false;

  meta = with lib; {
    description = "Tool used to brute-force URIs, DNS subdomains, Virtual Host names on target web servers";
    homepage = "https://github.com/OJ/gobuster";
    license = licenses.asl20;
    maintainers = with maintainers; [ pamplemousse ];
  };
}
