Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42732 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbYKMLxt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 06:53:49 -0500
Subject: Re: Master mode in iw
From: Johannes Berg <johannes@sipsolutions.net>
To: Mark Ryden <markryde@gmail.com>
Cc: Kalle Valo <kalle.valo@nokia.com>, linux-wireless@vger.kernel.org
In-Reply-To: <dac45060811130349k3153fcd6i9e6f35f9df3f52ef@mail.gmail.com> (sfid-20081113_124903_288051_86EB6C8C)
References: <dac45060811130246n41c9983fx2f06f85946b20c1c@mail.gmail.com>
	 <87ej1f6ggq.fsf@nokia.com>
	 <dac45060811130349k3153fcd6i9e6f35f9df3f52ef@mail.gmail.com>
	 (sfid-20081113_124903_288051_86EB6C8C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QI6pIj3xQQn/wYxg5MN0"
Date: Thu, 13 Nov 2008 12:53:13 +0100
Message-Id: <1226577194.5105.6.camel@johannes.berg> (sfid-20081113_125354_458690_B135F522)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QI6pIj3xQQn/wYxg5MN0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-11-13 at 13:49 +0200, Mark Ryden wrote:
> Hello,
> Thanks for you quick response.
> I know that I can set master mode with hostapd.
>=20
> My question is - is there something inherent which
> prevents implementing it with "iw"?
> When comparing to the old set of tools, which includes
> iwconifg,
> "iwconfig wlan0 mode Master" works on some interfaces.

Yes, the interface will do _nothing_ if you don't use hostapd.

johannes

--=-QI6pIj3xQQn/wYxg5MN0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJHBUmAAoJEKVg1VMiehFYdUEP/i5vy3n+YmpjmOBbsaJOIueq
GS0tUtYoCouGl0SDzqXhCS9w4KL22z6XiQf/CX49GXFEd5aUXQYFyUfQB5Ukcfx+
+5c56Rj0ln4euAiMqdVWCsncvABXoehro//yg8amEtuUKckRNqlElCJ+wfhr4sme
K/AG3rRra79drmi2KjQwzG/s8UIg+NVskbqsfnOw2ftl8ZZyUvFozNFo7dcAO7Yq
yKid/j2CRhCo4GNEUGkOu8guitWffxg33z+rtJCY7BVFbDqrJGqU/3D+yXjpXKz9
3zaxGr28mEhybIjmyZSEOmczF/YCvRVgXXT13liZdFfIo+M1rpmPQlwNxwpUYqdq
WL73Uw1QWx4MvFj5ZYN8vTINe/mkI9BjiH9sh9j6X03HWtk2K33d4Eqwl456qW7+
tDN9a0yAjvXtmH2UiBGmaopppOe7X8te/PNyV1zcyWQXqJpp22rCWJCKsOXDKdyR
XxdDXV39FEPYKnm3zDzp1GUc8jlGu6mXMQI0f3RWQgqH2hOTezjR13W7/XBURYb7
VNfORUO+omaikKYsc1zizLjTZG/F3JhbAY1rxT+dHDFpX7vfDf1F6spSslkoN1zD
F0v5QxUKcTwrmoeq3auzBKgq+gOM5CI1r47h/8KoCTyeGSxwOlGS13c4huGKJB8K
LVNRY6s6LglU3tZVjfio
=0g56
-----END PGP SIGNATURE-----

--=-QI6pIj3xQQn/wYxg5MN0--

