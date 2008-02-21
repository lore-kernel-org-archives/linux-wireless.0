Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39802 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbYBUTZS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 14:25:18 -0500
Subject: Re: [RFC] mac80211: allow specifying RTS/self-CTS protection when
	injecting packets
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Andy Green <andy@warmcat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080221161129.GB3094@tuxdriver.com>
References: <1203553034.17534.119.camel@johannes.berg>
	 <20080221161129.GB3094@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UTakHB/UaAm7bh1M+L+o"
Date: Thu, 21 Feb 2008 20:22:04 +0100
Message-Id: <1203621724.26341.2.camel@johannes.berg> (sfid-20080221_192536_427608_AB9042D6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UTakHB/UaAm7bh1M+L+o
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2008-02-21 at 11:11 -0500, John W. Linville wrote:
> On Thu, Feb 21, 2008 at 01:17:14AM +0100, Johannes Berg wrote:
> > I made this patch to test RTS/CTS operation in drivers, do you think
> > it's useful apart that and should be merged?
>=20
> I don't see why not...what would be the objection?

You can't specify "Don't send RTS/CTS" because not specifying either
flag means "automatic".

johannes

--=-UTakHB/UaAm7bh1M+L+o
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR73PW6Vg1VMiehFYAQIXEg/+NnavG7OD3NCFhTNgI+qoxHrsbXOT/JIj
3FedEX8we2+y5vs1hEqT2XoYVy9beoZUThOd8iOF5AhYocNcre1xexgpU50ge6Xb
NXg6GN17sqQQtrFcun9JcE/f9SPHr93oUbKTC/bHpiVu6OMlptx8jnW3dsGiY7eK
1nTFzfqksdrDYnsTGg0HsldDK3IwklhgZ141QDyu+/DyUCQM9zS8R5a+jTJOa2BI
ZZTmbKh3CccyzPn1FyVZeHc2Qs56vaFhWbL5CLaC9Ga8lrpxbAsbehh1SWYcsrzd
iOQOd7+v9QdHAgG+DeXg+3Rb03zDdI4CzpgXwSgAWWrU1zdmqAl/zeK+q5eh+zx8
G97Bk4HmPnXeuUCEDF0JXniFqG3zG5jQ6sSTpE2Bf3G8B7bW26F1rZlQG/lYw5EP
13O/sP5md1o9tWV8+Abc2PBfSaV+Jtq5JWtKOa6o/BveSZG4OEjmXz8vu5yhK3/s
Q1EfYEJrKCdR0qFNf3UzMgqjs5rjKXNgT+077hmUmErdDY1JKtprjKSiXJJaYF9s
DbLE2MQ/gmj242yKvdmUwvGN1IHK4pktum/HZvvg73senJ3IJKuIS8pimzgU0cXN
feniXX+5vO/YRl8ZaXl9xyQYYjqxWIJRMLuFAaBoChWIb7EvIZmEH247nm8N7Lm5
px+KsHjbnHU=
=Btcr
-----END PGP SIGNATURE-----

--=-UTakHB/UaAm7bh1M+L+o--

