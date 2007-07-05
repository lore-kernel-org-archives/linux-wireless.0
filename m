Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49421 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbXGFKg4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2007 06:36:56 -0400
Subject: Re: [PATCH] eeprom_93cx6: shorten pulse timing to match spec (bis)
From: Johannes Berg <johannes@sipsolutions.net>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: jgarzik@pobox.com, "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <20070703223144.GA13714@electric-eye.fr.zoreil.com>
References: <20070702210345.GA22610@electric-eye.fr.zoreil.com>
	 <20070703123441.GA3534@tuxdriver.com>
	 <20070703223144.GA13714@electric-eye.fr.zoreil.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-P1ll5tEKwNzcKCl8bxsB"
Date: Thu, 05 Jul 2007 18:44:29 +0200
Message-Id: <1183653869.3818.58.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-P1ll5tEKwNzcKCl8bxsB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-07-04 at 00:31 +0200, Francois Romieu wrote:
> Based on an original idea by John W. Linville.
>=20
> It is the missing part of 42d45ccd60636c28e35c2016f091783bc14ad99c
                            ^
I can't find that commit in the current wireless-dev tree, can you
provide a correct reference or more explanation? Then again the patch
itself is short enough and I don't understand the need for the reference
at all.

johannes

--=-P1ll5tEKwNzcKCl8bxsB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGjR/t/ETPhpq3jKURAmYhAJ4hMCVYX6pKmrZvf8hoOno8miBJkQCgqipG
z8pg0ydZEMLxNUaZA5BkieA=
=mUSu
-----END PGP SIGNATURE-----

--=-P1ll5tEKwNzcKCl8bxsB--

