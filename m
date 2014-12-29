Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:63206 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbaL2Nf0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2014 08:35:26 -0500
Message-ID: <54A15896.2020008@rempel-privat.de> (sfid-20141229_143529_451822_9F51C1AE)
Date: Mon, 29 Dec 2014 14:35:18 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	=?UTF-8?B?VGhvbWFzIEjDvGhu?= <thomas@net.t-labs.tu-berlin.de>,
	adrian@freebsd.org
Subject: Re: [RFC 0/3] add TPC capability for AR9002 based chips
References: <1419689545-26965-1-git-send-email-lorenzo.bianconi83@gmail.com>	<549FFB8F.9010701@rempel-privat.de> <CAA2SeNKxDk+sgpP9be=8MUgVOBHO26=oA4r4v+wRHfN1b6fH8w@mail.gmail.com>
In-Reply-To: <CAA2SeNKxDk+sgpP9be=8MUgVOBHO26=oA4r4v+wRHfN1b6fH8w@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="opwE1R6fgPMlEE237EA0XUfjhkP6iNNSO"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--opwE1R6fgPMlEE237EA0XUfjhkP6iNNSO
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 28.12.2014 um 15:32 schrieb Lorenzo Bianconi:
>> Hi, can you please describe some testcases for you patches.
>>
>=20
> This patchset adds Transmission Power Control (TPC) for AR9002 based
> chips. IOW it enables the capability of correct TX power on per-packet
> basis. It is preparatory for upcoming Thomas's joint rate and power
> control
>  algorithm.

Do you mean, right now there is no way to test your patches?


> Regards,
> Lorenzo
>=20
>> Am 27.12.2014 um 15:12 schrieb Lorenzo Bianconi:
>>> This patchset adds TPC capability to ath9k for AR9002 based chips
>>>
>>> *[RFC 1/3]: add TX power per-rate tables to cap TX power in TX descri=
ptor path
>>> *[RFC 2/3]: cap per-packet TX power according to TX power per-rate ta=
bles
>>> *[RFC 3/3]: enable per-packet TPC on AR9002 based chips by default
>>>
>>> This pachset is based on Adrian Chadd's hints
>>> (https://www.mail-archive.com/ath9k-devel@lists.ath9k.org/msg10396.ht=
ml)
>>>
>>> Lorenzo Bianconi (3):
>>>   ath9k: add power per-rate tables for AR9002 chips
>>>   ath9k: add TPC to TX path for AR9002 based chips
>>>   ath9k: enable per-packet TPC on AR9002 based chips
>>>
>>>  drivers/net/wireless/ath/ath9k/ar5008_phy.c  | 80 ++++++++++++++++++=
++++++++++
>>>  drivers/net/wireless/ath/ath9k/debug.c       |  5 --
>>>  drivers/net/wireless/ath/ath9k/eeprom_4k.c   | 14 +++++
>>>  drivers/net/wireless/ath/ath9k/eeprom_9287.c | 15 ++++++
>>>  drivers/net/wireless/ath/ath9k/eeprom_def.c  | 14 +++++
>>>  drivers/net/wireless/ath/ath9k/hw.c          |  3 +-
>>>  drivers/net/wireless/ath/ath9k/hw.h          |  2 +
>>>  drivers/net/wireless/ath/ath9k/xmit.c        | 66 ++++++++++++++++++=
+----
>>>  8 files changed, 181 insertions(+), 18 deletions(-)
>>>
>>
>>
>> --
>> Regards,
>> Oleksij
>>
>=20
>=20
>=20


--=20
Regards,
Oleksij


--opwE1R6fgPMlEE237EA0XUfjhkP6iNNSO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlShWJYACgkQHwImuRkmbWkdCwD/fH/fiPQUoLGo/O1I0a8oyHvM
3MymnVhy/Lc3JtWTQvMA/i9+rc2L8CnjGJFJZ3xAOt+V8Kw7e41OwKFYXbv2YNKu
=Wm1z
-----END PGP SIGNATURE-----

--opwE1R6fgPMlEE237EA0XUfjhkP6iNNSO--
