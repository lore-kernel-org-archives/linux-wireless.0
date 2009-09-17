Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45001 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbZIQXf6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 19:35:58 -0400
Subject: Re: regression?  No connection with master-2009-09-16 was fine
 until master-2009-09-14
From: Johannes Berg <johannes@sipsolutions.net>
To: ASIC Felix <ic.felix@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1253208348.6601.17.camel@darkslate>
References: <1253208348.6601.17.camel@darkslate>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-F3ZJ1urRKtb/DcoWu3jU"
Date: Thu, 17 Sep 2009 16:35:30 -0700
Message-Id: <1253230530.23567.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-F3ZJ1urRKtb/DcoWu3jU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-09-17 at 10:25 -0700, ASIC Felix wrote:

> ath9k: Two wiphys trying to scan at the same time

how about you stop playing with multi-wiphy things _first_?

and then describe your setup ... the patch works fine here and Holger
said it fixed his problem. hidden ssid by any chance?

johannes

--=-F3ZJ1urRKtb/DcoWu3jU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKsse/AAoJEODzc/N7+QmasR8P/i/SXLW67Yp9Bvi9iFPUP6uh
sCp1NU4FC773EwppMK9hlZB5eyNGgkjLdTFj38HwocLCjfHE+h4dpbNSENQic4NE
xT2vXsEptmFBLnt/E/3IiDk/fXglJHsFOjhkDK9fYmCyZucxjbpNwNJMta0aGpdK
Q8vtiizFigQ/viXKf2asjEKTXKWUHnQnhZNwh8Zkrx2QrICdN95XhljBv+QbwS/U
Irmvvz5BMux5YO8M4e1ksxpmnNlUH/AhGORX3b2qn9duTiS7ne7s/vWQ7bj3VZce
GPCCPMR61w7Zjn45hYU+Fb5P1q9T5GccW8ZifJBSZPut3oawlXwpNpcV4hxx1Ac7
l3HkAtM+C3FDOflagw122eyRb1/B513pD5J2VZ/k08sy1HfyRNT/n+jEdFHoemMF
kfIj4Phu2e2GoYRIH2Zx2+x7FWz6ZOVj4jcCfx2maSCXxYfn1poPvQY5Pw3H5PgP
Jq2FGX9E+Q7s9a13tqAbu+VwwR5i3RhYLGewkke7XdcHUqhRg8j9L2ln7r+8ZtJW
U5k6w/UItJGPQJv4p8inNUx9Q7ZvzJdrk6Tlm2sWd9yuAK6fw59yf7VYStkS4Ng0
nHPRreg2jLylliJ188x4COMks+1xp+ls9gTSAdTeSHgZTDmZZHaT8gBDAZPauFk+
fDSrauKT+yJ1lEZ0/4eB
=bWCT
-----END PGP SIGNATURE-----

--=-F3ZJ1urRKtb/DcoWu3jU--

