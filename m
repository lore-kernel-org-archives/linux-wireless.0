Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37091 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbZIBRbM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2009 13:31:12 -0400
Subject: Re: [PATCH 2.6.31] iwlwifi: Reenable power_level
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Andrew Lutomirski <luto@mit.edu>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <1251911825.13180.173.camel@rc-desk>
References: <cb0375e10909020753o4d314f61k74dd35025f61666a@mail.gmail.com>
	 <1251906970.13180.137.camel@rc-desk>
	 <cb0375e10909020941qa54215cqb6af7ac01e87ccb3@mail.gmail.com>
	 <1251910457.13180.160.camel@rc-desk>
	 <1251911029.2999.0.camel@johannes.local>
	 <1251911825.13180.173.camel@rc-desk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Zvx+w1m4CuO6yQs9T2u5"
Date: Wed, 02 Sep 2009 19:30:29 +0200
Message-Id: <1251912629.2999.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Zvx+w1m4CuO6yQs9T2u5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Reinette,

> The file itself was removed, but from what I understand the same
> functionality can now be obtained from sleep_level_override.=20

Indeed.

> Users who
> previously used power_level can thus now use sleep_level_override, but
> with sleep_level_override not existing in 2.6.31 they will have no
> alternative if we remove power_level.
>=20
> > So it
> > may be fair to remove it for .31 since there you can't use it anyway.
>=20
> You can still use it to manually set power index used by device to
> reduce power usage.

I was under the impression that Andrew said this actually didn't work.

johannes

--=-Zvx+w1m4CuO6yQs9T2u5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKnquxAAoJEODzc/N7+QmahdsP/0tn7gLnk2iT9imsx8LKZ+Bq
hEnIGHI42c6ZNB+r7ntH9Yc7HV4NRGqVpD7HqYhcuOldFOJHZuQgauh0C3PdDqVr
wrsGhWdzAxAIMeyMqnVhj+/qUJe6WbIuJQIJiEuVThUNMTZf0Ua0W993nCdGuFgL
8n/I8C2Ma+8PYFS0aoHrWnRTm8CLh5szojjGn8hktg2CrhPehrN6qYcSIGnet/yP
Iojsxb9kvrPDyk3OjlocMSkuCe5v9YxWN229pt8adkiHt9g6g7HvW+/f/YVOEWrX
IeVWogk63K7Tt7U862SPDK5q5bXMDIfWd1s6+fAhHYNBciNJN8WBx0vvWTU+Fgx0
nRRvOdCgYSIGa+BHhY/XaJ5F18xP1JXgXY8gFzSCejcdQFVBIyIaGZj84l4uTFPP
PatXmXYWPtA6q8LGxGwHLTYcPsbwZgzAoDNyWgjnNEUy+UNE299twWTWltTsAYFi
Bq/FltiUW1A/wDlx4WVvQ33a2ju0mcAHQQZ3YwVBlcx6dvUMHOgVU7leXLSBI7I2
0rbGBac05FrZBUELsgkDQwsct0GcPWHGNHvdqQ9OdHzlVDW7V9xAQaRBbBjVQrvq
dSSnH/3ScIFgFfkNLTYwWB7SAKqKbTXDSUv57jx/4vGYrkBPDlBjyJD3t3sWWsgC
hcwLZZrkBkpfYbG7szKt
=YnLi
-----END PGP SIGNATURE-----

--=-Zvx+w1m4CuO6yQs9T2u5--

