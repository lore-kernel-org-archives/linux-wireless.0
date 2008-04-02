Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:47074 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751721AbYDBKVQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 06:21:16 -0400
Received: from ironport-out-2.rz.rwth-aachen.de ([134.130.3.59])
 by mta-1.ms.rz.RWTH-Aachen.de
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0JYP00GTM0RFDQ00@mta-1.ms.rz.RWTH-Aachen.de> for
 linux-wireless@vger.kernel.org; Wed, 02 Apr 2008 12:21:15 +0200 (CEST)
Date: Wed, 02 Apr 2008 12:21:15 +0200
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: Re: RaLink RT2500 802.11g Cardbus/mini-PCI
In-reply-to: <200804012009.02448.IvDoorn@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
Message-id: <47F35E1B.8000103@archlinux.org> (sfid-20080402_112124_390171_5003768D)
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary=------------enig2ABC4CFFA2215D55C126D4C2
References: <35856.201.36.161.238.1206999707.squirrel@mamao.cetuc.puc-rio.br>
 <200804010010.15705.IvDoorn@gmail.com> <fstta0$jhu$1@ger.gmane.org>
 <200804012009.02448.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2ABC4CFFA2215D55C126D4C2
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

I rebuilt 2.6.25-rc8 (again) to use the 'simple' algorithm instead of=20
the 'PID' algorithm by default. rt2500pci is still fast!


--------------enig2ABC4CFFA2215D55C126D4C2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEAREIAAYFAkfzXhsACgkQEda5KzHP/VClXwCgpIbTUeaz4qPvLHPowAuW9bHJ
dbIAnR7gi1RQgbTabdALgbBOrgVrIxoB
=eSkV
-----END PGP SIGNATURE-----

--------------enig2ABC4CFFA2215D55C126D4C2--
