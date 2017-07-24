Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:55307 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750896AbdGXGBL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jul 2017 02:01:11 -0400
Subject: Re: Madwifi porting to Ath9k
To: Arul jothi <aruljkp@gmail.com>, linux-wireless@vger.kernel.org
References: <CAH3WNGT-tYhUr3sTD8gfeUDQQ4ihtVccqEFUAEfxU6q5Ro3wxg@mail.gmail.com>
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <77ba0bc6-f57d-013c-9523-b9d4b2eaa102@rempel-privat.de> (sfid-20170724_080115_423675_890E7660)
Date: Mon, 24 Jul 2017 08:01:03 +0200
MIME-Version: 1.0
In-Reply-To: <CAH3WNGT-tYhUr3sTD8gfeUDQQ4ihtVccqEFUAEfxU6q5Ro3wxg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hGnjcQ5AofLXHHbAtCiPppBeofHTIJrgv"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hGnjcQ5AofLXHHbAtCiPppBeofHTIJrgv
Content-Type: multipart/mixed; boundary="1FHvlEk4VGVrkjEWV4In0JdATFA82qtlO";
 protected-headers="v1"
From: Oleksij Rempel <linux@rempel-privat.de>
To: Arul jothi <aruljkp@gmail.com>, linux-wireless@vger.kernel.org
Message-ID: <77ba0bc6-f57d-013c-9523-b9d4b2eaa102@rempel-privat.de>
Subject: Re: Madwifi porting to Ath9k
References: <CAH3WNGT-tYhUr3sTD8gfeUDQQ4ihtVccqEFUAEfxU6q5Ro3wxg@mail.gmail.com>
In-Reply-To: <CAH3WNGT-tYhUr3sTD8gfeUDQQ4ihtVccqEFUAEfxU6q5Ro3wxg@mail.gmail.com>

--1FHvlEk4VGVrkjEWV4In0JdATFA82qtlO
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Am 23.07.2017 um 15:54 schrieb Arul jothi:
> Hi,
>=20
>   I have AR7161 based board which is using customized madwifi driver
> with PCF implementation.
> I need to port the driver to new board based on AR9344.
> What should be the approach I should take
>=20
> 1.       Build Madwifi with current AR9344 Openwrt build
>=20
> 2.       Implement PCF with current Ath9k driver.
>=20
>=20
> Please advise which approach I should take. Can someone help me with
> some clue on that.
> Thanks in advance.

In long term it is preferable to extend upstream version of the driver
(ath9k) aaand upstream you patches as well.

ath9k has big developer community and good testing coverage.

--=20
Regards,
Oleksij


--1FHvlEk4VGVrkjEWV4In0JdATFA82qtlO--

--hGnjcQ5AofLXHHbAtCiPppBeofHTIJrgv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF4EAREIAAYFAll1jR8ACgkQHwImuRkmbWnydwD/R5ZdS+cR3c1fbA75HKA3Co6h
4QtwgEBmYspslbdCn9IA+wZz1QMmVD/qwbRQ5F/Ok0p95a1SNOPfH4syCp2WkEuV
=X4dS
-----END PGP SIGNATURE-----

--hGnjcQ5AofLXHHbAtCiPppBeofHTIJrgv--
