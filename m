Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55503 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933941AbZLFSBP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 13:01:15 -0500
Subject: Re: [PATCH 1/4] nl80211: Add new WIPHY attribute COVERAGE_CLASS
From: Johannes Berg <johannes@sipsolutions.net>
To: 8an@praha12.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <200912061822.54088.8an@praha12.net>
References: <200912061820.26320.8an@praha12.net>
	 <200912061822.54088.8an@praha12.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-5rwGYtG6yDUgdOkI7hQV"
Date: Sun, 06 Dec 2009 19:01:17 +0100
Message-ID: <1260122477.3461.20.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5rwGYtG6yDUgdOkI7hQV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-12-06 at 18:22 +0100, Luk=C3=A1=C5=A1 Turek wrote:
> The new attribute NL80211_ATTR_WIPHY_COVERAGE_CLASS sets IEEE 802.11
> Coverage Class,

This patch assumes that all hardware supports this, which is not really
what you want. You'll want to know if it can't be set. Yes, we assume
rts/cts can be set always, but that's a _much_ safer bet.

johannes

--=-5rwGYtG6yDUgdOkI7hQV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLG/FqAAoJEODzc/N7+QmaTpwQAMq3QIUryBNpmozMxyPQwJ33
VnxHCSJ8xzNEetg2cC/y4SokHqpwFGovoQwkdfirilK8zR2IPc1qjymFWGjXpOS2
UdyDtAS+w5I1fT9qicZDMO9owZxsuFYaNs64cPpfnNtiF812YrD9hNEfvhpohcpk
RLKVIUhHASIF3sbTgd7D96sZ3/lflnddZjVSR4R9TxYZCSrOugWtbT+rwVd/fXWr
gCazN2m/+yFwR5pZtzU85Wizuus/kXr0nswP34oNfZWhY8nU8cbp5vpxPsMTBP8o
WINbPKGUar8uBLpktl6VFabQZ3guK09IaBwPjHVrOXtBlFhgL88XBYCbrt1opPFK
8t+gr6v9tG9Pk3z0TLy3lqI16xSrhj2xeR6ikQz3wj+wvLrvUmKcWgvVadKgrLRA
BTqhdlLe024YYANb5ACiheoAv/DAnFfIlehgkQEBtmxH8dM3cEsn4zB6mGfwNnXI
ycm3Nlxn5qp7YjnJUxdcvzua1Yxi3QNG5c/HqtX5ejVQQB5QI8lQ1Ou8u0T72oyX
+uS5ziijypQ2jNp8V2Ah3/l+Ezu7GGV5ku+kzylhgaT0oNOaETxX+bv4t4iknZU2
B+jkHhg1cdI4lW7HHj59ktaAFhGwK5+nnR0GlvCaJU/D1xHfq3RXQYQqTTQROD4x
IWtDk7p5WwPQ+1L+rdir
=7QX4
-----END PGP SIGNATURE-----

--=-5rwGYtG6yDUgdOkI7hQV--

