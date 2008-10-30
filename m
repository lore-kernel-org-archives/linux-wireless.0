Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33604 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbYJ3UsL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 16:48:11 -0400
Subject: Re: Guidelines regarding separate directory
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: Dave <kilroyd@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
In-Reply-To: <1225399481.7931.5.camel@dv>
References: <4909EA78.3060700@lwfinger.net>
	 (sfid-20081030_181107_189082_5740895D) <1225387309.3690.73.camel@johannes.berg>
	 <490A17F3.5050802@gmail.com>  <1225399481.7931.5.camel@dv>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-U7p4e/YBBr3ASTyO3gqp"
Date: Thu, 30 Oct 2008 21:48:02 +0100
Message-Id: <1225399682.3690.82.camel@johannes.berg> (sfid-20081030_214816_013280_BBA0B6B3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-U7p4e/YBBr3ASTyO3gqp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > orinoco_pci.c
>=20
> orinoco_pci.c is a good candidate for removal.  It only supports the
> hardware that is already supported by hostap_pci.

Wait wait. I think everybody would rather see hostap go than orinoco
since hostap is a huge complex thing and quite buggy.

johannes

--=-U7p4e/YBBr3ASTyO3gqp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCh1+AAoJEKVg1VMiehFYsUsP/1/B3R9u6foUF3kZ0ITaA9XJ
rEnw8/YhXBBWjMmWoqW7iRkBziQ1L+RTgWBXS6nq9XwPpA2e8LoFxyozMneEpfGP
QQKDTA7GswipvuYsi2hGe0ftXkOxahZtuQjdN0gK1Ds77wLj+hD2kshX8Ffi6ChV
PjDWLV7kKAMBtMKbF43C4N11W7C9Sm5FIrHvLKVdHqWZkWa1MzaX5gSsBS+KwY74
TY4WLx0bsinCO2sJS7/AXuJoAAXWEp6fPFd2Hx2WF0zNKD9zl/TzX5HxkYjF4Vs4
wn91P5Hn9cO45Bo26R82tLVvWFQa6lMCVhPqLYFNXXkx+f40kNx+6tr1lQKHHYZd
/Ono2/Ok/mgj2p/j/Gmpx60xnIZmiY97DcXIixc1/8VPNQz0/QBgQYXSqo9R0u21
DpAfilp0FqHnsc/YKYyZmiOK5ZViXEkSeIesOS5FH6/lP5+GGWENGDYZMSt4JMv1
8rgNinRc2O+/Qhz62soFLav33Y2bglgQZDgiL9V2ou29xLe6UIVIhmnIf72y8GZC
PLQ7m3denQrk5ScK2U+U49LPAK3lBIDYQ2V6zJTb3ioF2Lzij5x9uzfIq5qZ5XsY
FNkk9lxA/JtvQEVfy77iehXCdh9p3V3ajpj4W4D7/osU6tlCCliM1Pj1ePK3mwEc
PEppvicISaI6f0mpXqRx
=Hmc4
-----END PGP SIGNATURE-----

--=-U7p4e/YBBr3ASTyO3gqp--

