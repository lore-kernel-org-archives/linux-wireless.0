Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36849 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbZHRHXU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 03:23:20 -0400
Subject: Re: [PATCH 10/29] mwl8k: fix mwl8k_configure_filter() parameter
 lifetime issue
From: Johannes Berg <johannes@sipsolutions.net>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20090818040039.GA4116@mail.wantstofly.org>
References: <20090818035233.GO18639@mail.wantstofly.org>
	 <20090818040039.GA4116@mail.wantstofly.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-OkUNUQ3YlWG5wsf4uijL"
Date: Tue, 18 Aug 2009 09:23:18 +0200
Message-Id: <1250580198.30538.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OkUNUQ3YlWG5wsf4uijL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-08-18 at 06:00 +0200, Lennert Buytenhek wrote:

> This will clash with:
>=20
> 	http://article.gmane.org/gmane.linux.kernel.wireless.general/38141
>=20
> But that is easy to fix up.  (The easiest would probably be to not
> apply the mwl8k part of that patch, and I'll send a followup patch
> to implement ->prepare_multicast() for mwl8k.)

It's not quite that easy because that patch changes the arguments to the
functions so the multicast list is no longer available in
->configure_filter().

johannes

--=-OkUNUQ3YlWG5wsf4uijL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKilbiAAoJEODzc/N7+QmalPMP/AtcR0hL12nRcGQP+g1DzN3k
ZM/SqBDmsdu1a6bISmoLEv+wWStu7tFuNqqYqrHb4xUB3UED+Brt362gQ6UeQzpQ
djUC6k4TiqCG2p63OxJNY59eS0gSkyAMlw7s8+5yVIMdoC3zgaGj3M3DZM4JY0Ho
ypWPKFtb9jYBakspGYfdqimFOfPySVlw6g23qfdEhsLBu46P8k1+MmZAFFD515er
EzuoeRAvCb0KjjSi/vKu4WxOsNpwuiAFDRc3vt+Mw3+07MIe6O+aXQuEljaCV2VV
S7hOaAoG7yXXzfr3k1Z6QJSTzrPPmJUTvhvVfU2hLI0nw+tb7jpV8b9Eo/E3Ig8k
x0fXdYpPiODSfJ1/mrxutu9s5QJ8a6c4GISGOTb7Ve1afkSZlhOeAXYgZlORmzq2
o/M93tRce1zPsRv2/22Ay6GkG1/yxoGaNNzI8KZIjIzYEKR4My302C3bUVHSBC9Z
X44lWuNzuJHNSHBrkGa8rAfvVqMXeUFOsj83kaBKwIsZ0p1utiuNMaVmrVIbI1sm
tIRFRq/2JZa6PgLI7Y0uHeR2CEWz2uO3XzNTvgGfzMNLxRpvYJgBYhGt2Xq62CWi
FjUpyQKEsGzR2b6JCmqsj59ohquNQT++D++6O3crnvZqHa7KQnDsaAOOOGHzZZkA
1MwA6GA2VB2ufyfbDePB
=Ji5U
-----END PGP SIGNATURE-----

--=-OkUNUQ3YlWG5wsf4uijL--

