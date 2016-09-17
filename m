Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:54056 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752257AbcIQQO7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Sep 2016 12:14:59 -0400
Subject: Re: ath9k_htc kernel driver regression affecting throughput
To: bruce m beach <brucembeach@gmail.com>,
        linux-wireless@vger.kernel.org
References: <CAArymCkTyLUsxMsDJXVM=XvmFZAK-uWLLuP3gXSY9_hqcjWHjg@mail.gmail.com>
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <78432948-7580-2f07-872d-df261255255e@rempel-privat.de> (sfid-20160917_181502_370270_E982DF66)
Date: Sat, 17 Sep 2016 18:14:25 +0200
MIME-Version: 1.0
In-Reply-To: <CAArymCkTyLUsxMsDJXVM=XvmFZAK-uWLLuP3gXSY9_hqcjWHjg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FHSshHigClq6Tb0nkQrDVqDSLHhTfAdw7"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FHSshHigClq6Tb0nkQrDVqDSLHhTfAdw7
Content-Type: multipart/mixed; boundary="g2M1B3deGdr6dOXQU7dmUCW1X4MULDVXr";
 protected-headers="v1"
From: Oleksij Rempel <linux@rempel-privat.de>
To: bruce m beach <brucembeach@gmail.com>, linux-wireless@vger.kernel.org
Message-ID: <78432948-7580-2f07-872d-df261255255e@rempel-privat.de>
Subject: Re: ath9k_htc kernel driver regression affecting throughput
References: <CAArymCkTyLUsxMsDJXVM=XvmFZAK-uWLLuP3gXSY9_hqcjWHjg@mail.gmail.com>
In-Reply-To: <CAArymCkTyLUsxMsDJXVM=XvmFZAK-uWLLuP3gXSY9_hqcjWHjg@mail.gmail.com>

--g2M1B3deGdr6dOXQU7dmUCW1X4MULDVXr
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 17.09.2016 um 17:52 schrieb bruce m beach:
>>> Hm.. found here one report about bad perfomance on this driver
>>> https://ubuntuforums.org/showthread.php?t=3D2312343
>>>
>>> affected persons seems to use WEP encryption.
>>>
>>> What encryption do are you using?
>=20
> I just wish I could do some testing on a single machine. Every test
> suite I've seen always involves 2 machines. Why can't I use the wifi
> chip on the mother board and the ar9271(a usb stick) to test basic
> communications on the ar9271. The problem is I don't know where to begi=
n.
>=20
> Bruce
>=20

i didn't tried it myself:
https://unix.stackexchange.com/questions/122050/send-traffic-to-self-over=
-physical-network-on-ubuntu

but last suggestion looks interesting.

--=20
Regards,
Oleksij


--g2M1B3deGdr6dOXQU7dmUCW1X4MULDVXr--

--FHSshHigClq6Tb0nkQrDVqDSLHhTfAdw7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlfda/UACgkQHwImuRkmbWnumQEAl/6ApZFMG62CqzQ7G2NZ/TX0
cNjVgkbZse8WmjGYbh0A/RP5X0BhLZYxouP8UuhApH/SJBouG+kzy/jBI+khxbWI
=kqpx
-----END PGP SIGNATURE-----

--FHSshHigClq6Tb0nkQrDVqDSLHhTfAdw7--
