Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44405 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbYFCSxe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 14:53:34 -0400
Subject: Re: [PATCH 02/11] rt2x00: Fix compile-time ffs calculation macros.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <200806032029.40085.IvDoorn@gmail.com> (sfid-20080603_202609_676907_F946F45C)
References: <200806032024.52931.IvDoorn@gmail.com>
	 <200806032025.45029.IvDoorn@gmail.com>
	 <200806032029.40085.IvDoorn@gmail.com>
	 (sfid-20080603_202609_676907_F946F45C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-e7pfKyNRubD1hXkmFAVm"
Date: Tue, 03 Jun 2008 20:52:40 +0200
Message-Id: <1212519160.27643.33.camel@johannes.berg> (sfid-20080603_205337_838881_6E0D569D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-e7pfKyNRubD1hXkmFAVm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-06-03 at 20:29 +0200, Ivo van Doorn wrote:
> The compile_ffsx macros were missing a set of parentheses, which resulted=
 in
> wrong bit offset calculations.
>=20
> This fixes rt61pci detection failures, whereby the rf chipset wasn't dete=
cted
> properly due to improper bit shifting.
>=20
> This patch is based on GertJan's report + patch to fix the parentheses pr=
oblem

Sounds like you want to merge that with 1/11?

johannes

--=-e7pfKyNRubD1hXkmFAVm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASEWS9qVg1VMiehFYAQJtqxAAmKZ3Nm5fxxTVXj7JCOQUQ+pH4rJUDnrv
ErS4RRbipQ0LGDF+OX2vhIDBYG3HOacDC+z2GssUpk0+70eSV3PNC4sng8FNZevw
+/sc9WbEKAFA7QMxesbGDPG28Ch25bL1FLSZ/3dUAMUb4HDqOgomEXtnKURUQD38
bOd/G75iSfYDU87NDtqoHH0P0dvdK2rE9altwx2/pzf/kKoPNKFpjBAZQqfAQDdi
2UExphMiXRdQ3O2/bBNSGrZETf8FNg+E+uKQRrsk6elokq5Mgrjw/6+ivw4QGDmv
s/JipDVSLnIkCX6tkShtUmiF+yH/aWr3WFsSq0lQY9PycfWgEZUEJryGw8TM2khH
aDQFJw+WoKXA/Kanh9X/lnhCI76a5BLBLfDgAyOcKzcGlyxg7w7ocNyz2On0y7uR
06cjRdPQ8EA6ocJk85FKdxLzT1zuTPAYjwA+KZFhlMjhbcL0FCb0E+8wca2n7SKc
m4UgIYtMn9UJ8oiy5ecm+29P2neE4yns6w2QQU3+pe9YE+hqlzQ3TsX6Oa4bt2E0
R5XlvUoCvJnBCKfa9bb+HkVp8qO2/OS0ydGzFxv1rcie7QdCo3vNLQl/OMelVEnr
PpViYZT9R/3Jh6exgOfpX8kkuP9tZmu2lZFJ0+bRkz7zyY1kxN+mxfirbEHojhyT
MJyrHBGoQUQ=
=G6O6
-----END PGP SIGNATURE-----

--=-e7pfKyNRubD1hXkmFAVm--

