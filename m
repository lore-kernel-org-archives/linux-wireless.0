Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60692 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbZGWLBT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 07:01:19 -0400
Subject: Re: [PATCH 7/7] cfg80211: increase scan result expire time
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <200907231250.37025.helmut.schaa@googlemail.com>
References: <20090723100732.5147.73989.stgit@localhost.localdomain>
	 <20090723101428.5147.53956.stgit@localhost.localdomain>
	 <1248345595.19121.25.camel@johannes.local>
	 <200907231250.37025.helmut.schaa@googlemail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4TkRkn2F4ZJgPg8LZvyY"
Date: Thu, 23 Jul 2009 13:00:47 +0200
Message-Id: <1248346847.11510.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4TkRkn2F4ZJgPg8LZvyY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-23 at 12:50 +0200, Helmut Schaa wrote:
> Am Donnerstag, 23. Juli 2009 schrieb Johannes Berg:
> > On Thu, 2009-07-23 at 12:14 +0200, Helmut Schaa wrote:
> > > Using background scanning in mac80211 the time a scan needs to
> > > finish can exceed 10 seconds. Hence, increase the scan results
> > > expire time to 15 seconds which should be sufficient.
> > >    =20
> > > Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> >=20
> > Heh.
>=20
> ;)
>=20
> Maybe we could later use a dynamic expire time based on the time
> the last scan took or something similar. But for now 15 seconds
> should suffice.

Since we tell (or if we don't, should) userspace when that was last
seen, I guess we could just increase this more anyway. But ultimately it
doesn't matter all that much since people are just using wpa_supplicant
and keeping a copy in userspace.

johannes

--=-4TkRkn2F4ZJgPg8LZvyY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKaELcAAoJEODzc/N7+QmaS7IP/1paDrGaWuYQ9tMhVPawakTR
cYN1zqruQY3af+5Lb4FnOIXiLsOw7p/wd3I7+U+1PPwhE1KrTuD0qHMxocqXP8pr
BcdpHYxQDjZEBp3n8M1WKLPYZL8t9MsX0sKmEUonjLgCK9SJ470XMXXWrLBLpc0b
etKrLzYPhvkySGstEqzUxykeNSHxmJNseiP8bwlthH+jqEPFI4uYxyRC9png8yDK
d7Mt9T/qWvNyq7MzDED7uq/PtOOiFq/cYFLip24A7Dkha8awodcrTEcNtrbKbywZ
DkBZDZH8VK4zofiqy38ZAS+TBGjyZM9cQbGKQR3nhZqUOyqpQew+iGOHF5KoqTo8
Yw6H3UqrLOE2WmlD3Kf3BBQWY//4hA9qrAAIJYNbkDDN5WQhNMTxxhLANXb2rLnL
C0Pc6PYpVvNQlIUt+4OBBQKCQL3wJnxO2bnlEDcUY2cN+I27jxMol3BouMXwZDwn
cMoq8vvhUqN42QXO3LTaYlG09Dht4Htwt7OqcweurxVv1juvIPq08QKSG3r9MhJz
QGdfmFM+eGGzxS4WzVGPFzhbisblYLt+uxESFiLxNqzojtyIJ/zxbyfTK0fF8Ysn
zrqvJo0pSRO7nsSEW8+iTML/6VI20canAFG/Uzf+nW3Oqps07y2fiI2txCQr0gmQ
XmWWIjiKluvxzmPJYslt
=WuLj
-----END PGP SIGNATURE-----

--=-4TkRkn2F4ZJgPg8LZvyY--

