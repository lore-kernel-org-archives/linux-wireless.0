Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:65512 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331AbbGVRQS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 13:16:18 -0400
Message-ID: <55AFCFDE.7060902@rempel-privat.de> (sfid-20150722_191622_011380_17542D3F)
Date: Wed, 22 Jul 2015 19:16:14 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: rolf.anderegg@weiss.ch,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k_htc: virtual interfaces, AP connection drop & kernel warning
References: <559D41B3.4050604@weiss.ch> <559F9AF8.5000208@rempel-privat.de> <55A3A672.1060502@weiss.ch> <55A79B5C.7010501@rempel-privat.de> <55AFC6E1.7060706@weiss.ch>
In-Reply-To: <55AFC6E1.7060706@weiss.ch>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cCOHluhaxTd4Jsu03aue19j23Q970PxSV"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cCOHluhaxTd4Jsu03aue19j23Q970PxSV
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 22.07.2015 um 18:37 schrieb Rolf Anderegg:
>=20
> On 16/07/15 13:54, Oleksij Rempel wrote:
>> Am 13.07.2015 um 13:52 schrieb Rolf Anderegg:
>>>
>>> I suspect that there are bandwidth/speed issues when dealing with USB=

>>> adapters, but that does not inherently mean that the connection is pr=
one
>>> to drop, right? Doesn't that mean that I am leaking packages somewher=
e
>>> along the way? What else could I be looking for?
>>
>> The packages can drop if you will do channel scan. STA mode need some
>> seconds to complete channel scan. It means AP will be all the time
>> unavailable.
>=20
> Ok, that may be. Then again why am I not experiencing the same
> connection drop on my ath5k setup? Because the channel scan is more
> likely to be completed in due time?

Yes, channel scantime on usb device is match longer then on pci.

--=20
Regards,
Oleksij


--cCOHluhaxTd4Jsu03aue19j23Q970PxSV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlWvz94ACgkQHwImuRkmbWnNtwD6AwBOOM+E3FimwDj78ctBID7k
hp3uq6ozb0fZ2koYzj4A/RFlUUjLgCykYmCv4cn0TWzPViSY2GsDuAopU8Q32gRM
=ngAb
-----END PGP SIGNATURE-----

--cCOHluhaxTd4Jsu03aue19j23Q970PxSV--
