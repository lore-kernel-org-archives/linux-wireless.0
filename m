Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:62686 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751832AbdGXHTT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jul 2017 03:19:19 -0400
Subject: Re: Madwifi porting to Ath9k
To: Arul jothi <aruljkp@gmail.com>
References: <CAH3WNGT-tYhUr3sTD8gfeUDQQ4ihtVccqEFUAEfxU6q5Ro3wxg@mail.gmail.com>
 <77ba0bc6-f57d-013c-9523-b9d4b2eaa102@rempel-privat.de>
 <CAH3WNGQwXVQM9pMA-g_yFc3apb__aUxA1pir75LwifV7pgTA=g@mail.gmail.com>
Cc: linux-wireless@vger.kernel.org
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <b91c5424-baaf-c1e1-5d2b-51aad79b6991@rempel-privat.de> (sfid-20170724_091923_731131_9E50996F)
Date: Mon, 24 Jul 2017 09:19:16 +0200
MIME-Version: 1.0
In-Reply-To: <CAH3WNGQwXVQM9pMA-g_yFc3apb__aUxA1pir75LwifV7pgTA=g@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PujRACLKTQUiTNW5hSMmN7efQ8j0MTHsl"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PujRACLKTQUiTNW5hSMmN7efQ8j0MTHsl
Content-Type: multipart/mixed; boundary="4ked1aBWP6HQm4L2C6mRnoduxU2foD071";
 protected-headers="v1"
From: Oleksij Rempel <linux@rempel-privat.de>
To: Arul jothi <aruljkp@gmail.com>
Cc: linux-wireless@vger.kernel.org
Message-ID: <b91c5424-baaf-c1e1-5d2b-51aad79b6991@rempel-privat.de>
Subject: Re: Madwifi porting to Ath9k
References: <CAH3WNGT-tYhUr3sTD8gfeUDQQ4ihtVccqEFUAEfxU6q5Ro3wxg@mail.gmail.com>
 <77ba0bc6-f57d-013c-9523-b9d4b2eaa102@rempel-privat.de>
 <CAH3WNGQwXVQM9pMA-g_yFc3apb__aUxA1pir75LwifV7pgTA=g@mail.gmail.com>
In-Reply-To: <CAH3WNGQwXVQM9pMA-g_yFc3apb__aUxA1pir75LwifV7pgTA=g@mail.gmail.com>

--4ked1aBWP6HQm4L2C6mRnoduxU2foD071
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Am 24.07.2017 um 08:08 schrieb Arul jothi:
> Hi Oleksij,
>=20
>    Thanks for your reply. I am new to the linux wireless.
> Does ath9k has support for PCF implementation ? I couldn't find any
> reference about PCF in ath9k.
>=20
> Do you mean porting madwifi code to ath9k is straight forward ?.
> Please give some link or guideliness.

- Isolate PCF code in Madwifi
- port it to the ath9k if possible
- do lots of testing
- send patches for review.

--=20
Regards,
Oleksij


--4ked1aBWP6HQm4L2C6mRnoduxU2foD071--

--PujRACLKTQUiTNW5hSMmN7efQ8j0MTHsl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAll1n3QACgkQHwImuRkmbWkVHAD6A3eZG+btLCmglHiyKc58CWZe
0W1ARQg27Hs3wz7qEBoBAIWQIW2/xXHbd4LuogBW6MSp+IkHhdFUEbQUfWSltL0/
=L8mu
-----END PGP SIGNATURE-----

--PujRACLKTQUiTNW5hSMmN7efQ8j0MTHsl--
