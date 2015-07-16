Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:56478 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490AbbGPLyJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2015 07:54:09 -0400
Message-ID: <55A79B5C.7010501@rempel-privat.de> (sfid-20150716_135414_510009_8C31F82D)
Date: Thu, 16 Jul 2015 13:54:04 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: rolf.anderegg@weiss.ch,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k_htc: virtual interfaces, AP connection drop & kernel warning
References: <559D41B3.4050604@weiss.ch> <559F9AF8.5000208@rempel-privat.de> <55A3A672.1060502@weiss.ch>
In-Reply-To: <55A3A672.1060502@weiss.ch>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jemb7E2e6nwxhQHAK08a3PpkUo9NiSrxQ"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jemb7E2e6nwxhQHAK08a3PpkUo9NiSrxQ
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 13.07.2015 um 13:52 schrieb Rolf Anderegg:
>=20
>> First of all, you are using ancient kernel and firmware. Please update=

>> it. Firmware should be at leas 1.4 and kernel probably 4.1 or later. i=
'm
>> not sure which include patch with support of RMW command introduced by=

>> new FW.
>>
>> Then you can try to disable LED blinking which is stealing your usb
>> bandwidth.
>=20
> Thanks for your suggestions.
> You say ancient, I was thinking longterm stable. For various reasons I
> require a RT patched kernel, alas this is not yet available for 4.1
> kernels. Aside from that I have updated the kernel and firmware as you
> propose. Also I have set ath9k_htc's blink=3D0. The kernel warnings are=
 no
> longer occuring, however the AP's connection (which requires several
> attempts) is still dropped after a few seconds.
> I suspect that there are bandwidth/speed issues when dealing with USB
> adapters, but that does not inherently mean that the connection is pron=
e
> to drop, right? Doesn't that mean that I am leaking packages somewhere
> along the way? What else could I be looking for?

The packages can drop if you will do channel scan. STA mode need some
seconds to complete channel scan. It means AP will be all the time
unavailable.

> Regards,
> Rolf Anderegg
>=20


--=20
Regards,
Oleksij



--jemb7E2e6nwxhQHAK08a3PpkUo9NiSrxQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlWnm1wACgkQHwImuRkmbWlWBgD+Knd5Rce+SoISXkXxXjwA7ZMb
AvWrnLl3a+nWxrrl+vUA/iw0IWxzHHzOI3GkF+C8slp9wQR0uyxigXR9j+KjDZaC
=vtdN
-----END PGP SIGNATURE-----

--jemb7E2e6nwxhQHAK08a3PpkUo9NiSrxQ--
