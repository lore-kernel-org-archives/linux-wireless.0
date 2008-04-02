Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:65202 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750935AbYDBJaz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 05:30:55 -0400
Received: from ironport-out-2.rz.rwth-aachen.de ([134.130.3.59])
 by mta-1.ms.rz.RWTH-Aachen.de
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0JYO004E9YFIEB30@mta-1.ms.rz.RWTH-Aachen.de> for
 linux-wireless@vger.kernel.org; Wed, 02 Apr 2008 11:30:54 +0200 (CEST)
Date: Wed, 02 Apr 2008 11:13:03 +0200
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: Re: RaLink RT2500 802.11g Cardbus/mini-PCI
In-reply-to: <200804012009.02448.IvDoorn@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
Message-id: <47F34E1F.6030201@archlinux.org> (sfid-20080402_103111_783213_7E9EA24A)
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary=------------enig963F458F5FEACA17A4787F6F
References: <35856.201.36.161.238.1206999707.squirrel@mamao.cetuc.puc-rio.br>
 <200804010010.15705.IvDoorn@gmail.com> <fstta0$jhu$1@ger.gmane.org>
 <200804012009.02448.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig963F458F5FEACA17A4787F6F
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

Ivo van Doorn schrieb:
> Hi,
>=20
>>>> Is the last kernel code working with RaLink RT2500 802.11g Cardbus/m=
ini-PCI?
>>> With 'latest' do you mean:
>>>  latest 2.6.25-rc kernel?
>>>  latest wireless-testing git snapshot
>>>  latest rt2x00 git snapshot
>>>
>>> The latter 2 should work fine, the first one has known issues
>>> but the state variates per person.
>> I was complaining about speed a while ago, so after reading this post,=
 I=20
>> thought I should try again and tell you:
>>
>> The version in wireless-testing seems to work great, a test download=20
>> gave me 1.24MB/s, which is about the same speed I get with my (Intel=20
>> wireless) laptop. I am using rt2500pci.
>>
>> Does the above mean that the stock driver in 2.6.25 will still be slow=
?
>=20
> Most likely yes.
> Although I hear mixed reports, some say it depends on the rate selectio=
n
> algorithm, some claim rt2x00 in 2.6.24 is faster then wireless-testing =
and
> others claim the exact opposite.
> At the moment it is hard to tell, but I haven't collected data yet with=
 specific
> information about the used rate selection module and exact data transfe=
r
> numbers.
>=20
> Ivo
>=20

Okay, I tried again with 2.6.25-rc8 from linux-2.6 git. Speed is still=20
great. However, with both wireless-testing and linux-2.6 I seem to be=20
using the 'pid' algorithm:

phy0: Selected rate control algorithm 'pid'

With 2.6.24 I seem to be using the 'simple' rate control algorithm. I=20
don't know how to switch rate control algorithms without rebuilding=20
though, so I can't test 'simple' with 2.6.25.


--------------enig963F458F5FEACA17A4787F6F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEAREIAAYFAkfzTiAACgkQEda5KzHP/VC/yACeP/WJs4uGdMTkvqoL4DuTvswL
K1cAniPUQ+NcdCLeYT8NpF8YoS08SLx8
=n5E8
-----END PGP SIGNATURE-----

--------------enig963F458F5FEACA17A4787F6F--
