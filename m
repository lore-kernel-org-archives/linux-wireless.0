Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:46699 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755826AbYDJWHo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2008 18:07:44 -0400
Received: from ironport-out-1.rz.rwth-aachen.de ([134.130.3.58])
 by mta-1.ms.rz.RWTH-Aachen.de
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0JZ400IYWQSUXL70@mta-1.ms.rz.RWTH-Aachen.de> for
 linux-wireless@vger.kernel.org; Fri, 11 Apr 2008 00:07:42 +0200 (CEST)
Date: Fri, 11 Apr 2008 00:07:41 +0200
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: Re: RaLink RT2500 802.11g Cardbus/mini-PCI
In-reply-to: <200804021932.26046.IvDoorn@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>,
	linux-wireless@vger.kernel.org
Message-id: <47FE8FAD.9020802@archlinux.org> (sfid-20080410_230749_942393_2DFE7A46)
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary=------------enigCF1D35155E28AFE1C119EC6F
References: <35856.201.36.161.238.1206999707.squirrel@mamao.cetuc.puc-rio.br>
 <200804012009.02448.IvDoorn@gmail.com> <47F35E1B.8000103@archlinux.org>
 <200804021932.26046.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCF1D35155E28AFE1C119EC6F
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

Ivo van Doorn schrieb:
>>>> Does the above mean that the stock driver in 2.6.25 will still be sl=
ow?
>>> Most likely yes.
>>> Although I hear mixed reports, some say it depends on the rate select=
ion
>>> algorithm, some claim rt2x00 in 2.6.24 is faster then wireless-testin=
g and
>>> others claim the exact opposite.
>>> At the moment it is hard to tell, but I haven't collected data yet wi=
th specific
>>> information about the used rate selection module and exact data trans=
fer
>>> numbers.
>>>
>>> Ivo
>>>
>> I rebuilt 2.6.25-rc8 (again) to use the 'simple' algorithm instead of =

>> the 'PID' algorithm by default. rt2500pci is still fast!
>=20
> Good to hear. :)
>=20
> Thanks for the test.
>=20
> Ivo

Bad news again:

With 2.6.25-rc8, rt2500pci is fast. When I apply this patch:
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.25-rc8-git=
8.bz2
on top of rc8, then it is slow again. I can't make sense of it, maybe=20
you can.


--------------enigCF1D35155E28AFE1C119EC6F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEAREIAAYFAkf+j60ACgkQEda5KzHP/VBAAgCfSxqSeJv2SS7rGY1XrDgUt21I
Ou4AoKD8azTZTXxdJe/nS3VP3Mc7ZzO/
=n+KF
-----END PGP SIGNATURE-----

--------------enigCF1D35155E28AFE1C119EC6F--
