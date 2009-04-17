Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48821 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbZDQMNP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2009 08:13:15 -0400
Subject: Re: p54 problem with PS
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>
In-Reply-To: <200904171356.58336.chunkeey@web.de> (sfid-20090417_135736_024791_EE50B564)
References: <1239823495.20927.1.camel@johannes.local>
	 <200904162157.20576.chunkeey@web.de>
	 <1239913104.26575.25.camel@johannes.local>
	 <200904171356.58336.chunkeey@web.de> (sfid-20090417_135736_024791_EE50B564)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-QQj7hyvpJP7Z9u2/f0+B"
Date: Fri, 17 Apr 2009 14:12:41 +0200
Message-Id: <1239970361.26575.89.camel@johannes.local> (sfid-20090417_141321_432303_074A441C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QQj7hyvpJP7Z9u2/f0+B
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-04-17 at 13:56 +0200, Christian Lamparter wrote:

> +       priv->beacon_timeout_guard =3D jiffies;

I wonder if you shouldn't do this when CONF_PS is (first?) enabled
instead? Or add_interface?

johannes

--=-QQj7hyvpJP7Z9u2/f0+B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ6HI1AAoJEKVg1VMiehFYC50P/3kIGYQWfx311tNcHPZKLfmW
au42NHXol+4s2VvHfYhyD+BluFf29qtZBOVkAQjyQMK6eBweRnyhe2WEynx41MTZ
dlhJ2Emon3uEw0s0kJ/0lyjCXmy8yLmanEeJe/R6NQWEMKrWRN9qghqRwRiMoNWK
eL1SefFfUDgfPN/a8CbqmJVjiPqJB77j+jlO8cgu01OCaIjZH/d8X69lWNZRXaUk
Bhbt6kYSGRIu9lV8TKerYjnzvPofoyVdXenDY82esupg8K7kWGBGX6eJ1Yg7RsjN
azeN3zbQJF4Yuoj1uEUJGLS43RP0jA7EXj4wult9pbZu/g0joUXoq/79jHCM4EnW
LOHRr4zsNsHolBJ5Kx2dfli/zy+IUYape47r2T0NusyLUOjslx0CBqZHxM4occYB
WW1WJ7FP5RKpHYTQUKrR5O6e5+KkK9JYWmP/nYlag0ARnVdoaIpDWySBfaeROVUw
14JtyZ6Y2xDOzuRqouqHgAAGbfMkGMkMR+imNX7HuIACueuNHLB6jbzLO6rL51Pp
kdKgEmHaECjIFzXp4jwAkgytxO4laf5NtHRXuWRGx/jtH8JnzCodGyPJ13pHQG3h
81bkluhlgCbZngs2P4N6u92t6W9YcFhKeqJrjvW42hu6YS0U0hHMScyecuOKqdbz
68jAVcYrJY2WEyZbvELa
=+kPa
-----END PGP SIGNATURE-----

--=-QQj7hyvpJP7Z9u2/f0+B--

