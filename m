Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59323 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbZDROcs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2009 10:32:48 -0400
Subject: Re: bad reference to atheros ar71xx config variable?
From: Johannes Berg <johannes@sipsolutions.net>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0904181020490.25540@localhost.localdomain> (sfid-20090418_162436_362181_72D1EA2C)
References: <alpine.LFD.2.00.0904181020490.25540@localhost.localdomain>
	 (sfid-20090418_162436_362181_72D1EA2C)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-fr0iobh5GQvJYji6Nyhm"
Date: Sat, 18 Apr 2009 16:32:43 +0200
Message-Id: <1240065163.20540.3.camel@johannes.local> (sfid-20090418_163252_060750_E9875425)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fr0iobh5GQvJYji6Nyhm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-04-18 at 10:23 -0400, Robert P. J. Day wrote:
> ./drivers/net/wireless/ath9k/Makefile:ath9k-$(CONFIG_ATHEROS_AR71XX) +=3D=
 ahb.o
>=20
>   there appears to be no such config variable.  is that a typo?

That's some embedded system iirc, maybe the arch code hasn't gone in
yet?

johannes

--=-fr0iobh5GQvJYji6Nyhm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ6eSGAAoJEKVg1VMiehFYdAcP/3rZUQSixvc27uFKPbHR35Fd
ZS2vMhO1PfcpzSwntLcwwZkxOdln6+K/NVvF2viQzUZ9jcfY1dcJ4QRpws5x+Cj4
VxLq7EzYXjBK7OjFNi8KKJLnRT2JhNw9DosHoKFKIbGmy8FKX1eJhR+ywjsxepjh
5CdneA7rDYH2hNmhxuHNhqnMEttImRf7B4+kDiJsvKB8md/rCP/0wl45JOnqyR/P
XLbQt2xRGEd+fJteW05W5DvPKIuci0OqFsGn1QDtcb8E2arpV1ZY63uE+ylNIcXY
Es0s0QH73/TgqnSz3mZgiDv0n/ygBmAd0ygCK7MvTSQG4bjK6+SE2YlKfcB6VuT8
l8m6dDrLnEytH448G3VJLHlPFmvSeRU5mNC4FIHLY4+U4LwUrpaZAndWXJ5xM7Ik
Y05zmnq/bKusaw8nZsl4SkG87mlKs6fL3iOl6boeYn38YROlSiIZL788Vqmu6XVF
WCQvc5FSA9E62A1puctL+uER3tp67ifUUuDIX1Yi5VgVq0TksoENu0a8JNk4y7Vn
4zDg1hnyytZkgTnUFwmiU7ht+LinpNARI8iKXO23hntjfcfLB7ozVyAOJvMT8y/O
+dn8mEIok+HKyT0f/BLfEJxHjSuXXQIoo1uXt8ZLbc3PHQ1sQSQ3/9/AQlHbF+Zy
uq8WuTctgXAZf1TydQIX
=gNv7
-----END PGP SIGNATURE-----

--=-fr0iobh5GQvJYji6Nyhm--

