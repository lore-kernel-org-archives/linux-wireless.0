Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44556 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab0IEILx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Sep 2010 04:11:53 -0400
Received: by wyf22 with SMTP id 22so1779957wyf.19
        for <linux-wireless@vger.kernel.org>; Sun, 05 Sep 2010 01:11:52 -0700 (PDT)
From: Florian Fainelli <florian@openwrt.org>
Reply-To: Florian Fainelli <florian@openwrt.org>
To: Robert Chan <robert.chan.list@gmail.com>
Subject: Re: undefined reference to `ar71xx_add_device_dsa'  ???
Date: Sun, 5 Sep 2010 10:12:55 +0200
Cc: linux-wireless@vger.kernel.org
References: <AANLkTimq7nB-ea1XmORprBiS2B-OBNtEiiQXAZLzZfA2@mail.gmail.com> <1283660758.18358.8.camel@patrick-olevia>
In-Reply-To: <1283660758.18358.8.camel@patrick-olevia>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3465462.3nenR0h8Xy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <201009051013.00355.florian@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3465462.3nenR0h8Xy
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello,

Le Sunday 5 September 2010 06:25:58, Robert Chan a =C3=A9crit :
> Dear all,
>=20
> I am trying to compile backfire with virtually the default config I
> downloaded, except that:
>=20
> 1.  Changed the default platform to ar71xx/TP-Link TL-WR741ND v1;
> 2.  Enabled mesh networking (pre-802.11s) support (in Networking
> Support).
>=20
> And nothing else.  Then I got the following error:
>=20
> ....................
> arch/mips/ar71xx/built-in.o: In function `ap91_eth_init':
> (.init.text+0x13b8): undefined reference to `ar71xx_add_device_dsa'
> arch/mips/ar71xx/built-in.o: In function `ap91_eth_init':
> (.init.text+0x13b8): relocation truncated to fit: R_MIPS_26 against
> `ar71xx_add_device_dsa'
> make[5]: *** [vmlinux] Error 1
> ......................
>=20
> Can anyone please give me some pointer?

Your question should be directed to the openwrt-devel mailing-list. Thank y=
ou.
=2D-
=46lorian

--nextPart3465462.3nenR0h8Xy
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkyDUQgACgkQlyvkmBGtjyYf4ACfYrWxDQKx8hYdbcUcy1hu1L2u
P2QAoLc1JBW9F1ZFv1/QILbGKo8sVzTS
=D/wD
-----END PGP SIGNATURE-----

--nextPart3465462.3nenR0h8Xy--
