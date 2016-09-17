Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:53897 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752597AbcIQQYI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Sep 2016 12:24:08 -0400
Subject: Re: ath9k_htc kernel driver regression affecting throughput
To: bruce m beach <brucembeach@gmail.com>,
        linux-wireless@vger.kernel.org
References: <CAArymCkTyLUsxMsDJXVM=XvmFZAK-uWLLuP3gXSY9_hqcjWHjg@mail.gmail.com>
 <78432948-7580-2f07-872d-df261255255e@rempel-privat.de>
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <b017ac03-87a3-1188-93a9-162462dbdbe0@rempel-privat.de> (sfid-20160917_182424_833436_6647F383)
Date: Sat, 17 Sep 2016 18:23:54 +0200
MIME-Version: 1.0
In-Reply-To: <78432948-7580-2f07-872d-df261255255e@rempel-privat.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3VlNwd6oH9qKFNilCrPoX74oiVHMG10qB"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3VlNwd6oH9qKFNilCrPoX74oiVHMG10qB
Content-Type: multipart/mixed; boundary="RCHG3g9e4rt9KTt2454oxIhix5BtXs3ow";
 protected-headers="v1"
From: Oleksij Rempel <linux@rempel-privat.de>
To: bruce m beach <brucembeach@gmail.com>, linux-wireless@vger.kernel.org
Message-ID: <b017ac03-87a3-1188-93a9-162462dbdbe0@rempel-privat.de>
Subject: Re: ath9k_htc kernel driver regression affecting throughput
References: <CAArymCkTyLUsxMsDJXVM=XvmFZAK-uWLLuP3gXSY9_hqcjWHjg@mail.gmail.com>
 <78432948-7580-2f07-872d-df261255255e@rempel-privat.de>
In-Reply-To: <78432948-7580-2f07-872d-df261255255e@rempel-privat.de>

--RCHG3g9e4rt9KTt2454oxIhix5BtXs3ow
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 17.09.2016 um 18:14 schrieb Oleksij Rempel:
> Am 17.09.2016 um 17:52 schrieb bruce m beach:
>>>> Hm.. found here one report about bad perfomance on this driver
>>>> https://ubuntuforums.org/showthread.php?t=3D2312343
>>>>
>>>> affected persons seems to use WEP encryption.
>>>>
>>>> What encryption do are you using?
>>
>> I just wish I could do some testing on a single machine. Every test
>> suite I've seen always involves 2 machines. Why can't I use the wifi
>> chip on the mother board and the ar9271(a usb stick) to test basic
>> communications on the ar9271. The problem is I don't know where to beg=
in.
>>
>> Bruce
>>
>=20
> i didn't tried it myself:
> https://unix.stackexchange.com/questions/122050/send-traffic-to-self-ov=
er-physical-network-on-ubuntu
>=20
> but last suggestion looks interesting.
>=20

or this:
https://www.spinics.net/lists/netdev/msg152621.html

please share if you get it work :D

--=20
Regards,
Oleksij


--RCHG3g9e4rt9KTt2454oxIhix5BtXs3ow--

--3VlNwd6oH9qKFNilCrPoX74oiVHMG10qB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlfdbhoACgkQHwImuRkmbWls7gEAiEdFg630tg/Ru0yrqkbnf/7Q
RX3vRG71fplv0fygaqAA/Rfvb1JFurMP2K/EDcY3eWlmhq7vc5ePuNoO2oDc7yDb
=msn5
-----END PGP SIGNATURE-----

--3VlNwd6oH9qKFNilCrPoX74oiVHMG10qB--
