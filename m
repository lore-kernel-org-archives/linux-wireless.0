Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54379 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198AbZLNRYS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 12:24:18 -0500
Subject: Re: mac80211 or ath9k? No connect to other band after resume
From: Johannes Berg <johannes@sipsolutions.net>
To: ASIC Felix <ic.felix@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1260811290.2612.21.camel@darkslate>
References: <1260811290.2612.21.camel@darkslate>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-H38IXrf74miGJVIAS2jZ"
Date: Mon, 14 Dec 2009 18:24:16 +0100
Message-ID: <1260811456.2442.422.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-H38IXrf74miGJVIAS2jZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-12-14 at 09:21 -0800, ASIC Felix wrote:
> Hi,
>=20
> I found a suspend/resume bug.
> Kernel 2.6.32-wl-45997-gf02c03a master-2009-12-07
>=20
> To reproduce:
> - connect to 2G network (my office)
> - pm-suspend
> - resume (at home, wpa_supplicant.conf only has 5G home network)
> - laptop only scans 2G, never sees 5G AP
> - workaround:=20
>     /etc/init.d/network stop
>     rmmod bla bla bla
>     modprobe ath9k
>     /etc/init.d/network start
> - now laptop reconnects

I'd guess regulatory -- enable debugging for that please.

johannes

--=-H38IXrf74miGJVIAS2jZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLJnS3AAoJEODzc/N7+Qma+FYQAKULsER2MilfCWsRFWmaohmL
ZHeVwdgEdn0DkXx2c5xsPgtkrFIX1MBYG+RYVD1l8w48q+EPqkdzK0AhG0FmcSMd
OccL+WpbWWZyMbgrHwpvyTtcbx1pI+CzFA1lTQXc9uCGF+hdYXvZKnIiCkNv3E21
gApE3yjlIBy5ABVWVZlo2iJZSap/X3DFdt64XYrQkqgIdwpUD2bv4fZ2kBqtk1mK
PdCjG6J1eyIu5bLArn7BK7WiCTHuczkZZ6QrGhdldv22lhGC4PjPuCFwz1HIeDzA
hUXLt6HdiSQB9IwzwIwshycTEd5HL4maweV0IMygXmqjL3xwTbOUEhJ/SDyjlDJx
ssLxSfsJpqbXK+0WfepfDBHK7qvS1I8hDL9YlCzW9yYwirJxlE8+4eWiR3pnihRa
oYz2+1PTHaqFM8hnhrHFhNW6I8IJ2SahOu2YgP5H4sW2D+8SLuJAg7F+mgHQH8q0
U0L2858wj3+iV0as3Yjf9hzQ0eDjUcidfGf80UjRImeqzbmXi/orQ4I7AX+eZE/v
1vLaVhnpjlofw+/mMZY94tbmF+o6lPi9yVw+SLQCGBYhyWPSqzg83/ZcIkbNlDTr
9Xnf/JzYqanINTCaD61zldwXsnH7rhXWdZDQh8yQb8YeYcmXFU9+nMjSUEXOcDqy
3Uks+QBXR2qBQYdFrTBR
=hVJ5
-----END PGP SIGNATURE-----

--=-H38IXrf74miGJVIAS2jZ--

