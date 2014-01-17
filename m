Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:59165 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbaAQWCO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 17:02:14 -0500
Received: from [192.168.1.221] ([93.218.75.192]) by mail.gmx.com (mrgmx003)
 with ESMTPSA (Nemesis) id 0MDQI1-1W7HlG06PN-00Gqxb for
 <linux-wireless@vger.kernel.org>; Fri, 17 Jan 2014 23:02:12 +0100
Message-ID: <52D9A85E.8070306@rempel-privat.de> (sfid-20140117_230236_763932_D71D8DEB)
Date: Fri, 17 Jan 2014 23:02:06 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>, Julia Lawall <Julia.Lawall@lip6.fr>
CC: ath9k-devel@lists.ath9k.org, kernel-janitors@vger.kernel.org,
	ath5k-devel@lists.ath5k.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 0/11] use ether_addr_equal_64bits
References: <1388427307-8691-1-git-send-email-Julia.Lawall@lip6.fr> <20140117212410.GA13930@amd.pavel.ucw.cz>
In-Reply-To: <20140117212410.GA13930@amd.pavel.ucw.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wPeiUu57NahR2I82nneDslo4JQxIfmkgx"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wPeiUu57NahR2I82nneDslo4JQxIfmkgx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 17.01.2014 22:24, schrieb Pavel Machek:
> On Mon 2013-12-30 19:14:56, Julia Lawall wrote:
>> Ether_addr_equal_64bits is more efficient than ether_addr_equal, and c=
an be
>> used when each argument is an array within a structure that contains a=
t
>> least two bytes of data beyond the array.
>=20
> I mean, yes, it is probably faster, and yes, most structures probably
> contain two more bytes, but... is the uglyness worth the speedup? I'd
> say this should not be done except in very time-critical places...
> 									Pavel

This code run on every received beacon, almost on every wifi driver (If
i understand what you mean.)

--=20
Regards,
Oleksij


--wPeiUu57NahR2I82nneDslo4JQxIfmkgx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlLZqF4ACgkQHwImuRkmbWkVzQD/RakXROCReQFxlfH2WUvcgm/s
h27RY898nl6Txplcd1QA/iBcXdKSu5CM6doc8bhMe1aOLsa1rkxYGv+fLl1IwOwr
=oOX1
-----END PGP SIGNATURE-----

--wPeiUu57NahR2I82nneDslo4JQxIfmkgx--
