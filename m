Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41733 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262AbYJ2Ly4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 07:54:56 -0400
Subject: Re: [PATCH] wireless: clean up sysfs code using %pM
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20081028.220733.88410572.davem@davemloft.net>
References: <1225198854.3598.6.camel@johannes.berg>
	 <20081028.220733.88410572.davem@davemloft.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ImuYZEynuPKA6IvnbjYp"
Date: Wed, 29 Oct 2008 12:54:51 +0100
Message-Id: <1225281291.5439.4.camel@johannes.berg> (sfid-20081029_125501_428486_16909017)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ImuYZEynuPKA6IvnbjYp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-28 at 22:07 -0700, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Tue, 28 Oct 2008 14:00:54 +0100
>=20
> > Remove converting the MAC address to a string by a direct byte
> > conversion and use %pM instead, since the code is now boilerplate
> > use a macro to define the show functions, and also use the shorter
> > __ATTR_RO macro to define the attributes.
> >=20
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > ---
> > John, just FYI, it needs to go through net-next-2.6 since it depends on
> > %pM. Won't cause conflicts either :)
>=20
> I'll let John get this one.

Hmm. That means it won't get into 2.6.29 because John doesn't branch
from your next tree but rather from Linus's tree, and thus we can't use
%pM yet. I can resend then, doesn't matter much.

johannes

--=-ImuYZEynuPKA6IvnbjYp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCE8HAAoJEKVg1VMiehFYCBUP/2p5AfshUhb/jMVo+0uIGVbg
yZXiaqhM/PwowaMuHnkSg3N/wD9/xQdn/1h1fY6yhS2AA6paaxnV6ybNE4mZy+cB
fw3FGnWUJPeo/JOPorFL263D/xiZMBN7MnSJ1/4tfqgfD2QC3trzlLAKFiKmGqbG
+uHC6hQYAGuv6VsgUMOx8oMXX/zVEVOLBcrxczvgPB5AYrI1wwaCJyiZEWp2o/hz
aPegF5xNF78aAmmclUaR4o3L25/eO0T2JYxHvdrk0ImU+8cjFzDKU5svC8QxGw0y
r+CA5R1upIpbI91lomQHDRujs+PtpUa++SGF0cWmC8cGuAzHjnnUxv+qCpNjQUQE
0exgAoG9N5WZpzdh9GoidXhhzcaVQflWNhE2Iac6OHUhcukootpdK9ZLRMPWoCG6
LEhvxLDZOWnK5UofK4iUVA1eYOVgr6iqDwtHaH0haiWDw4q1soOhHabqV4Uh8l8L
M54Sswy2nNxglHPXDeGpLXI4eM9/mRruk8SnqEfd9dz1rVXg7dsh+YM7dTJo11yC
XX/ODxB30Ptl9FamFR9KWA7eih8faoF8npYgGBPvahFoQkD2kTeopO7DTtKPGYtV
yTksL5JXZ/+hLBeOkwfUORGpLibS0H7eqQuI4pOyyUb5vQNSOH5f9hsDIJqsRyIq
KPlkBozlspMlrGFOlxY4
=IPiW
-----END PGP SIGNATURE-----

--=-ImuYZEynuPKA6IvnbjYp--

