Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33739 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab0AKWU4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2010 17:20:56 -0500
Subject: Re: [PATCH 3/6] b43: N-PHY: add RSSI calculation for PHY rev < 3
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	bcm43xx-dev@lists.berlios.de,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <201001112313.26197.mb@bu3sch.de>
References: <op.u6b70wtk9lhzdc@linux-g0th.site>
	 <201001102338.28721.mb@bu3sch.de>
	 <b170af451001111313r6bc6905fg722fcd42d7f2681a@mail.gmail.com>
	 <201001112313.26197.mb@bu3sch.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8UTs8hiQh1R7olw4pAn+"
Date: Mon, 11 Jan 2010 23:19:52 +0100
Message-ID: <1263248392.29743.13.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8UTs8hiQh1R7olw4pAn+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-01-11 at 23:13 +0100, Michael Buesch wrote:

> No I don't think so.
> It's C standard that uninitialized elements on automatic variables are
> initialized
> to zero, _if_ at least one element is initialized to something.
> So if you init one element to 0, all others will be 0, too.

AFAIK, you don't even have to init anything, since otherwise not
mentioned fields will be set to 0. Hence, just =3D {} is sufficient for
arrays and will hopefully compile to the same code as an explicit
memset().

johannes

--=-8UTs8hiQh1R7olw4pAn+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLS6QEAAoJEODzc/N7+QmaRUMP/johEtSLm/t/G2vfPlFxzhq4
j9MPNm9yLw4e8zWXeAtDmy66povNRt2X1XoU7ZAssFOHPbmWhaocEt/F2jXDkhW/
56TgciG6XNqcCJE5DcFLcPg118qRov3MlQwywqsSKz9PI9NuorgmrG+b7oy1rxrG
fPfeoXZofrYtV6Ginav5lAfr5DskU5vIzdhfowp4shrOC5wNbJ++ETFXgYX+aHB9
T49Qay7cVrKyvCC5rUVBsgLEA5Ar3htkbs+HQ8nadgFoXcjf8BvidI3pt+l/In3B
b2xaDPGirB+C+y2ZqbmSLWmRiZQs+V0c4D2cCt3Fkechm9/8xiyqguaji4W2+94i
hJNBwXMA7qfXKZkJ7hHAjpyOrQwswSDg0gfleaafrUVN9gs31y6bXiBLettEMMQZ
3LWO8nbskzuWYhDuj1hYhASu4ljr1jA4M9ezXIJLwuhYFOXQNiUKIJwr9KgKHk1E
HSpOs6+65kB0loGFobXo/SoP8AzuF8fC1A+V1ruL4T/VOomKPeMh5zK/Vl6Ee++8
DNaW3FRroAxkxmGbNXtEeB2gqHO9ShEtZizjwk8j+as4bsWXUQp9yrG9jOYpT4We
z3KEeF8k9h1ai6HEfdwCFyrGvfdEzsbQZGaLGmvnPXIVGFEP1t8FBEqz0j/25+ji
howqABpGybhETpXT11mk
=sCWA
-----END PGP SIGNATURE-----

--=-8UTs8hiQh1R7olw4pAn+--

