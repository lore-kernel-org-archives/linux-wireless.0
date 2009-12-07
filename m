Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45483 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933235AbZLGLEx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2009 06:04:53 -0500
Subject: Re: [PATCH 2/4] mac80211: Add new callback set_coverage
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: 8an@praha12.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <87r5r73v91.fsf@purkki.valot.fi>
References: <200912061820.26320.8an@praha12.net>
	 <200912061823.45809.8an@praha12.net>  <87r5r73v91.fsf@purkki.valot.fi>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-L/tYm7PajdY6tmvEzb5e"
Date: Mon, 07 Dec 2009 12:04:24 +0100
Message-ID: <1260183864.3737.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-L/tYm7PajdY6tmvEzb5e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-12-07 at 12:59 +0200, Kalle Valo wrote:
> Luk=C3=A1=C5=A1 Turek <8an@praha12.net> writes:
>=20
> > Mac80211 callback to driver set_coverage() sets slot time and ACK timeo=
ut
> > for given coverage class. The callback is optional, but it's essential =
for
> > long distance links.
>=20
> [...]
>=20
> > + * @set_coverage: Set slot time for given coverage class as specified
> > + *	in IEEE 802.11-2007 section 17.3.8.6 and modify ACK timeout
> > + *	accordingly. Optional function, could be NULL.
> > + *

Also, should be %NULL for kernel-doc :)

johannes

--=-L/tYm7PajdY6tmvEzb5e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLHOE0AAoJEODzc/N7+QmaFdgP/06havKazK4/qF4gBJrPO0Pc
LALEy7FKNtcKsWXkqviCYXdNFQe1x3sMYsyghra6CZ4hV03uSvboDQyEpFtzHDYk
OI2PTWWngThsdYzTF8+hJ5xQQkm5FVr/ZEQSaox/xYM+XUrFdsxWULRCREEYufUX
e9WXKwRW0RAdfQO8VUWj53F/7ZZbO9RQddIOMXXS3B8Pj2p7MMy/FxWlC6H+PenA
UxAz8oImigk7F7D3hI3EBRQtVw3xsM2XBjvwYW77Wfd+i+wkuglCQ9VgnvbUVdJJ
O2E9Wm4UceaHPfNjk11te8hHwZsxLjMz27XvKwovKUziBPYcKEKjK2kmUrZJ1AFp
dx0RL8CSXcGxAkx2ZzHjNtIatKdZ3regq+SEYC5xtRRoxmIaZ1ONsijiGll+iZq/
4vNKHWP3DLvsosz/1jOG0j9Nsdc4buG1RiQmcxsvsbt/3XBBNBiyIx8v+YujxQkC
whttPuEbfAJ5cdhPLynL6WxEuOIsLewuPoUqb46E2hJYFhbAuVfJLVUe1IZyCliD
QyXYQahWHDUoHh2SiG1vD6nMOdY7BhNFCZHP98wDAooW1gO6uI8WHTJsIbl/lbMX
jJS40LpTCod20zvj3BQPxsfemIVOXkt0XDxEa0mRBHe68PmiMe7CACq+/Ukmm/G/
+M/8QEaZUwKPlVzYq7c0
=isME
-----END PGP SIGNATURE-----

--=-L/tYm7PajdY6tmvEzb5e--

