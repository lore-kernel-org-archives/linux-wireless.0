Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38455 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbZA0JFY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 04:05:24 -0500
Subject: Re: [PATCH 0/7 v2] airo: cleanups and simplifications
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1232748914.447.2.camel@localhost.localdomain> (sfid-20090123_231647_256810_FBC442D8)
References: <1232748914.447.2.camel@localhost.localdomain>
	 (sfid-20090123_231647_256810_FBC442D8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BoKsCq088SDsVTUG8hcU"
Date: Tue, 27 Jan 2009 10:05:15 +0100
Message-Id: <1233047115.4012.10.camel@johannes.local> (sfid-20090127_100529_988298_EEF98B53)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BoKsCq088SDsVTUG8hcU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-23 at 17:15 -0500, Dan Williams wrote:
> airo needs some hot sexy love.  come and get your love come and get your
> love now.

Still needs some!


+drivers/net/wireless/airo.c:3846:8: warning: symbol 'i' shadows an earlier=
 one
+drivers/net/wireless/airo.c:3757:6: originally declared here
+drivers/net/wireless/airo.c:3853:8: warning: symbol 'i' shadows an earlier=
 one
+drivers/net/wireless/airo.c:3757:6: originally declared here
+drivers/net/wireless/airo.c:3867:7: warning: symbol 'i' shadows an earlier=
 one
+drivers/net/wireless/airo.c:3757:6: originally declared here
+drivers/net/wireless/airo.c:1315:33: warning: restricted degrades to integ=
er
+drivers/net/wireless/airo.c:2056:10: warning: incorrect type in assignment=
 (different base types)
+drivers/net/wireless/airo.c:2056:10:    expected restricted unsigned short=
 [usertype] status
+drivers/net/wireless/airo.c:2056:10:    got unsigned short [unsigned] [use=
rtype] status
+drivers/net/wireless/airo.c:2108:14: warning: incorrect type in initialize=
r (different signedness)
+drivers/net/wireless/airo.c:2108:14:    expected unsigned int [usertype] *=
fids
+drivers/net/wireless/airo.c:2108:14:    got int *<noident>
+drivers/net/wireless/airo.c:2132:14: warning: incorrect type in initialize=
r (different signedness)
+drivers/net/wireless/airo.c:2132:14:    expected unsigned int [usertype] *=
fids
+drivers/net/wireless/airo.c:2132:14:    got int *<noident>
+drivers/net/wireless/airo.c:2173:14: warning: incorrect type in initialize=
r (different signedness)
+drivers/net/wireless/airo.c:2173:14:    expected unsigned int [usertype] *=
fids
+drivers/net/wireless/airo.c:2173:14:    got int *<noident>
+drivers/net/wireless/airo.c:2197:14: warning: incorrect type in initialize=
r (different signedness)
+drivers/net/wireless/airo.c:2197:14:    expected unsigned int [usertype] *=
fids
+drivers/net/wireless/airo.c:2197:14:    got int *<noident>
+drivers/net/wireless/airo.c:3211:11: warning: cast to restricted type

johannes

--=-BoKsCq088SDsVTUG8hcU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJfs5FAAoJEKVg1VMiehFY9HEP/1vH7zTJBIf0JBE/lBSUG1wC
KxH5zbDqJz5zuPptLZOZ17yBJjroa1Hb9LbnFOLKu8eVQBocJpIZhHcZPycHPmNo
9YHCiaWOZw+38Nyu7H6qLmEy6NS7hbEN5x6FlRCe2G4s0vpuuujrBABxECUQK5Jm
ab7xbAPtmJyGtwaivgbjdzZmxY5dtLavQMYLocg7LC+5FqvvKR1xDQr238y4KQvM
fujVPmY/ra9WKEedIBE+mF/ve4DxgdOxsrnepafDrH96V67a9cSmGLVqeVEe8Hbx
Ahc+8Lg4nGm3bQnJ+sQwX5vlxdiVSPyo/w+KolXa04hSWgJ3jnZveKhois447aTH
EMRM953IAbFnYxg+0556AxhiRMSAi8CZ/SqaZXqXRdF/0tnyayc6IyZwzw1vO0xS
qMXeePxRzBUiUUPLGI+ji/7OxJNO+uvf6JvGW9mJTDA5iczyCEtOo8VPcApY0yWz
vIbaIibp5B3dD1Tmk5Lv2M3xwQfI9LLiAHD+xHs0XFUyNeiM3x5tJNnER6LpRiH3
JCfEpiwmCCyJRlR4fErulcslw7WUZ5dWu7lvjwivOGJKKyy5YDkGVlPCbAqk8Tmz
2y4NUFc5vFprELArF8c5j06ryGUlJ4sE6RPhKFwXijHQwL2vb6lj4+eojbqN+2Ao
jjshtUuEgheKrFEohl1B
=CbWP
-----END PGP SIGNATURE-----

--=-BoKsCq088SDsVTUG8hcU--

