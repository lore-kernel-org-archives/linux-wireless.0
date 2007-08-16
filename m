Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53361 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562AbXHPNRg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 09:17:36 -0400
Subject: Re: [PATCH v2] hostapd: remove vlan stuff
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070816012239.GQ1415@jm.kir.nu>
References: <1187131269.31200.3.camel@johannes.berg>
	 <1187180689.3998.41.camel@johannes.berg>  <20070816012239.GQ1415@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zcLE+QDgJFIaxLZgtA1V"
Date: Thu, 16 Aug 2007 15:20:14 +0200
Message-Id: <1187270414.5141.42.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zcLE+QDgJFIaxLZgtA1V
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-15 at 18:22 -0700, Jouni Malinen wrote:

> This doesn't sound like a good idea. How would macvlan-based alternative
> solve the problem of having different group keys for each VLAN?

Ah. I never considered that was even possible. Wouldn't it make more
sense to allow binding group keys to STAs too, instead of making the
only within the interface? That way you could possibly even get hw accel
for those.

johannes

--=-zcLE+QDgJFIaxLZgtA1V
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD4DBQBGxE8O/ETPhpq3jKURAnzEAJ9+fwoyKCleBwCzlBoib933RK98owCXVBfW
BLSUv6kCg0XC0U0wFevBPw==
=3Ol+
-----END PGP SIGNATURE-----

--=-zcLE+QDgJFIaxLZgtA1V--

