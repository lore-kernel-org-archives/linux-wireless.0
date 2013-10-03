Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gw90.de ([188.40.100.199]:49007 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921Ab3JCJPI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Oct 2013 05:15:08 -0400
Message-ID: <1380789747.8125.9.camel@mattotaupa> (sfid-20131003_111516_049835_A8D60FCC)
Subject: Re: [rt2x00-users] [PATCH] rt2x00: rt2800lib: remove duplicate
 rf_vals for RF3053.
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Kevin Lo <kevlo@kevlo.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Date: Thu, 03 Oct 2013 10:42:27 +0200
In-Reply-To: <524D2139.4000608@kevlo.org>
References: <524D2139.4000608@kevlo.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-0T5UB44Zm1SqrS5HVlOW"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0T5UB44Zm1SqrS5HVlOW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Donnerstag, den 03.10.2013, 15:48 +0800 schrieb Kevin Lo:
> We already have rf_vals_3x with same values.  Hence rf_vals_3053 is remov=
ed
> in this patch.
>=20
> Signed-off-by: Kevin Lo <kevlo@kevlo.org>
> ---
>=20
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c=20
> b/drivers/net/wireless/rt2x00/rt2800lib.c

[=E2=80=A6]

Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>

--=-0T5UB44Zm1SqrS5HVlOW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iEYEABECAAYFAlJNLfMACgkQPX1aK2wOHVjnRACfeOJzbv5X4mfOdpNGsKTx3t6S
e/IAnRu8YPzlLYJOkwEwq9RNCIU4uwTb
=sE4Y
-----END PGP SIGNATURE-----

--=-0T5UB44Zm1SqrS5HVlOW--

