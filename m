Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58513 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbYJFTsw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 15:48:52 -0400
Subject: p54 build failure
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Chr <chunkeey@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8fasM6eduyhzmFPdWSou"
Date: Mon, 06 Oct 2008 21:48:21 +0200
Message-Id: <1223322501.3778.20.camel@johannes.berg> (sfid-20081006_214855_267715_8A60821A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8fasM6eduyhzmFPdWSou
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

p54_parse_eeprom must not be static, or it fails to build on powerpc:

drivers/net/wireless/p54/p54common.c:482: error:
__ksymtab_p54_parse_eeprom causes a section type conflict


johannes

--=-8fasM6eduyhzmFPdWSou
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6muCAAoJEKVg1VMiehFY77YP/3QRSxwSrLwyRquotN/fm7gC
JZmtLg3fmu2Vc/Fy1B6Yd69TCTJ36fJk3v+UgVvpC4xyj7PzEFH1JToXjCLwPXDc
FyHddwaT9fQVG2Pq59yA6CKfghETu4g4jn6b23zYdZQ2fpcJXc2kpPZuPjeh3xvJ
wgjun5gEvIYgj4Rb9dr+SkgF8PdDY8erlnBg6aPG+FKWbI/UGgspaa0AiQfogEtJ
O3F6t0SfvEfbfPd4IZ7e5NC0OUNI1hSpQMIcNaBykRUjJsvqMahd60k/SUvDoC4T
VdyLzWemTc7FctkKvtBxuCzgpcvIIr9o5W+kAQK9n0DwRTmUFRLOgua9WG8nTBAK
MPrjMqI2iE8yPEpqoFu54OHqs3qPVoji//416R5MsJg3mQpYI6H3odr07yK08upa
AiiKyY+4UeWnlNCk3+fuokj217jQoRnWby7BWAtmbNTKDV5ClTJwDc9j2BKt8JHE
pM8Pi2Ci5lBawBk3wAj8U9307Yuc4FJRsUbZqV4yAfrBo9tysj+yjksSx7jWX+iA
s/DNLiG63SQrkiOO/fWJjK2VCu8ZuVeGCKFa9PBP69GscWDv/o0OKwl2vucXi1HL
axqYe5toPOjHbxT5ClCp8oAEL7ZQ+LaLJ/sTNFTru+s00xfmCco720JV6ppw4CY4
EY5rzvpMA4fz5eBbS+9X
=OCA4
-----END PGP SIGNATURE-----

--=-8fasM6eduyhzmFPdWSou--

