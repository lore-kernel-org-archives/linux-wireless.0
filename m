Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:62401 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750709AbdETLDY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 May 2017 07:03:24 -0400
Subject: Re: Search for devices with Xtensa cores
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: ath9k-devel@qca.qualcomm.com,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org
References: <1fdab9d5-d8c6-88dc-38ac-2948e5fa74ec@rempel-privat.de>
 <CAMo8Bf+xbS46Kj4VP_+F2aZPZpOJ2UHV6WdHP_Ku_eaSQwm-7g@mail.gmail.com>
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <1855b2ff-3ed0-a2c3-ad27-7971fa92ee98@rempel-privat.de> (sfid-20170520_130407_825725_97257AB9)
Date: Sat, 20 May 2017 13:02:35 +0200
MIME-Version: 1.0
In-Reply-To: <CAMo8Bf+xbS46Kj4VP_+F2aZPZpOJ2UHV6WdHP_Ku_eaSQwm-7g@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pAhHodKCb7gkBHUDcVR4dI3LF89ADOHAw"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pAhHodKCb7gkBHUDcVR4dI3LF89ADOHAw
Content-Type: multipart/mixed; boundary="3RmeA5vnFOPCLsfIIHBvJjJLnQX9B1i7l";
 protected-headers="v1"
From: Oleksij Rempel <linux@rempel-privat.de>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: ath9k-devel@qca.qualcomm.com,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 ath10k@lists.infradead.org
Message-ID: <1855b2ff-3ed0-a2c3-ad27-7971fa92ee98@rempel-privat.de>
Subject: Re: Search for devices with Xtensa cores
References: <1fdab9d5-d8c6-88dc-38ac-2948e5fa74ec@rempel-privat.de>
 <CAMo8Bf+xbS46Kj4VP_+F2aZPZpOJ2UHV6WdHP_Ku_eaSQwm-7g@mail.gmail.com>
In-Reply-To: <CAMo8Bf+xbS46Kj4VP_+F2aZPZpOJ2UHV6WdHP_Ku_eaSQwm-7g@mail.gmail.com>

--3RmeA5vnFOPCLsfIIHBvJjJLnQX9B1i7l
Content-Type: text/plain; charset=utf-8
Content-Language: ru
Content-Transfer-Encoding: quoted-printable

Am 16.05.2017 um 21:46 schrieb Max Filippov:
> HI Oleksij,
>=20
> On Fri, Apr 28, 2017 at 11:23 PM, Oleksij Rempel <linux@rempel-privat.d=
e> wrote:
>> this year started with inclusion of open-ath9k-htc-firmware to debian
>> *main* repository. As first we started to getting advantage of regular=

>> compile tests. See results here:
>> https://tests.reproducible-builds.org/debian/rb-pkg/unstable/i386/open=
-ath9k-htc-firmware.html
>>
>> Most of the problems which we currently get, are related to gcc xtensa=

>> compiler.
>> In details: device specific patch set is used to provide our own
>> gcc/binutils version because Xtensa don't really have defined CPU core=
s.
>> As result, upstream compiler developers will never notice if some thin=
g
>> will brake this patch set.
>=20
> Below are the links to the xtensa-dynconfig repository and xtensa-plugi=
n-env
> branches in binutils-gdb and gcc repositories. Together it is a draft
> implementation of dynamically configurable xtensa toolchain.
> Could you please take a look at it and see if it's useful for you?
>=20
> https://github.com/jcmvbkbc/xtensa-dynconfig
> https://github.com/jcmvbkbc/binutils-gdb-xtensa/commits/xtensa-plugin-e=
nv
> https://github.com/jcmvbkbc/gcc-xtensa/commits/xtensa-plugin-env

I didn't tested it jet, but it looks promising. How can i itegrate this
two patches?
https://github.com/olerem/open-ath9k-htc-firmware/tree/master/local/patch=
es


--=20
Regards,
Oleksij


--3RmeA5vnFOPCLsfIIHBvJjJLnQX9B1i7l--

--pAhHodKCb7gkBHUDcVR4dI3LF89ADOHAw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF4EAREIAAYFAlkgIlAACgkQHwImuRkmbWmu3AD9HiEncsncqAtV/Cn9W70QNB3e
0uwEaF80sC5WuqQGGosBAIc4dRA8LCjVM4cRJASP5fBxdm+NceIHGIyhlTFTkTNT
=kncH
-----END PGP SIGNATURE-----

--pAhHodKCb7gkBHUDcVR4dI3LF89ADOHAw--
