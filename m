Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51505 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947AbYCCV1d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2008 16:27:33 -0500
Subject: Re: [PATCH 00/10] mac80211: fix mesh remaining issues
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <47cc5d75.24bc720a.7d54.ffffacc3@mx.google.com> (sfid-20080303_202012_190534_9E638A96)
References: <47cc5d75.24bc720a.7d54.ffffacc3@mx.google.com>
	 (sfid-20080303_202012_190534_9E638A96)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-m8MNrsvNeZh2P5yXaMNQ"
Date: Mon, 03 Mar 2008 22:27:21 +0100
Message-Id: <1204579641.3917.62.camel@johannes.berg> (sfid-20080303_212737_267701_4D6D9E6A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-m8MNrsvNeZh2P5yXaMNQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2008-02-29 at 12:13 -0800, Luis Carlos Cobo wrote:
> This patches fix all the remaining issues in the mesh implementation in
> wireless-testing. The sparse endianness warnings have been solved and the=
 mesh
> option is no longer marked as BROKEN.
>=20
> This applys on top of wireless-testing 6d85dc1886.

Patches all look good, thanks.

For all 10 of them, here's my

Acked-by: Johannes Berg <johannes@sipsolutions.net>

just in case somebody cares. :)

johannes

--=-m8MNrsvNeZh2P5yXaMNQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8xtN6Vg1VMiehFYAQK3PQ//S3/xjM27vT95oY7EX2VP54LQPQfHQoIj
keNHRBVoFDbNjh993tW9VjIMzY02SdpNU8AHfizanRJWslFDiwMQWIluBQ1h4QXn
3ZyvvVw9wHP7USQw7IoGujeDpksneTtq+27Yxda4+Aq52v8kGP9WBUbAbDG7dnCF
EHLH9g4N8+ZhZWed/Cmo4J+Y1PAHY/aAHw395r15shjDiMjTVj9iTxxI4Ysf+NQM
+0urjWvEBV++eElhX3beLjqMaEgPWEVEQRs9IKN3UQ0WU7FPm0p+7eTV9fWQqY41
jYhjJKULwKqcQJu3WVrhXvP0GVNvccb5JmI33fuL8lKLXijCXHuLG8GwW4NqZwbe
rE/1tLMnM4akqolIIZTgSigCYU4+kuIw33iGOq1yb5cQI4IXTp0EAQJQ7fnulLK0
/Je9jgKN1oe+/npOo37ehCXdiGkJarFc1hNajImOZm9AVl+TlF406eSwr2Mbx31o
tuEEWm2xpWehfE8jjqa0v7kxeYpZojplMQ7d2Jz9mCJk+oY4C7duTSx/bmigq/AK
lzwJShp1RUSrD2TK4ok+WNhItQzpSkQNDxQ/yyfPBzMdRbMn+x1DgDl14qcBUkqd
MyEfKkhMxZHkaMvrT/oSdEufRJIQpRykl26rOc5W2EO83Gelw9sqWpk2SjlpjyBz
3wnCCeh60A4=
=hJZt
-----END PGP SIGNATURE-----

--=-m8MNrsvNeZh2P5yXaMNQ--

