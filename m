Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s2.udvp.de ([188.40.48.165]:57504 "EHLO s2.udvp.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712Ab1IRAQU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Sep 2011 20:16:20 -0400
Message-ID: <4E75384F.8050501@somakoma.de> (sfid-20110918_021623_906552_BDFEF064)
Date: Sun, 18 Sep 2011 02:16:15 +0200
From: Manuel Munz <freifunk@somakoma.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: No beacons in ad-hoc mode with b43
References: <4E751496.30903@somakoma.de> <CACna6rxN+9ZJVnt-WGpxvyUrnBO9gnVOcTeZD9=eJZOUjJcgww@mail.gmail.com>
In-Reply-To: <CACna6rxN+9ZJVnt-WGpxvyUrnBO9gnVOcTeZD9=eJZOUjJcgww@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8CF86EE3A8C6C72BEE81A8F4"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8CF86EE3A8C6C72BEE81A8F4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 18.09.2011 00:13, Rafa=C5=82 Mi=C5=82ecki wrote:

> Please give us at least
> lspci -nn | grep 14e4
> dmesg | grep b43
>=20

Hi,

here is the info you requested:

# dmesg |grep b43
b43-phy0: Broadcom 4712 WLAN found (core revision 7)
Registered led device: b43-phy0::tx
Registered led device: b43-phy0::rx
b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)

# lspci -nn | grep 14e4
00:00.0 Host bridge [0600]: Broadcom Corporation BCM47xx V.92 56k modem
[14e4:4712] (rev 01)
00:01.0 Host bridge [0600]: Broadcom Corporation BCM47xx V.92 56k modem
[14e4:4712] (rev 01)
00:02.0 Host bridge [0600]: Broadcom Corporation BCM47xx V.92 56k modem
[14e4:4712] (rev 01)
00:03.0 Host bridge [0600]: Broadcom Corporation BCM47xx V.92 56k modem
[14e4:4712] (rev 01)
00:04.0 Host bridge [0600]: Broadcom Corporation BCM47xx V.92 56k modem
[14e4:4712] (rev 01)
00:05.0 Host bridge [0600]: Broadcom Corporation BCM47xx V.92 56k modem
[14e4:4712] (rev 01)
00:06.0 Host bridge [0600]: Broadcom Corporation BCM47xx V.92 56k modem
[14e4:4712] (rev 01)
00:07.0 Host bridge [0600]: Broadcom Corporation BCM47xx V.92 56k modem
[14e4:4712] (rev 01)
00:08.0 Host bridge [0600]: Broadcom Corporation BCM47xx V.92 56k modem
[14e4:4712] (rev 01)
00:09.0 Host bridge [0600]: Broadcom Corporation BCM47xx V.92 56k modem
[14e4:4712] (rev 01)
00:0a.0 Host bridge [0600]: Broadcom Corporation BCM47xx V.92 56k modem
[14e4:4712] (rev 01)
00:0b.0 Host bridge [0600]: Broadcom Corporation BCM47xx V.92 56k modem
[14e4:4712] (rev 01)
00:0c.0 Host bridge [0600]: Broadcom Corporation BCM47xx V.92 56k modem
[14e4:4712] (rev 01)
00:0d.0 Host bridge [0600]: Broadcom Corporation BCM47xx V.92 56k modem
[14e4:4712] (rev 01)
00:0e.0 Host bridge [0600]: Broadcom Corporation BCM47xx V.92 56k modem
[14e4:4712] (rev 01)
00:0f.0 Host bridge [0600]: Broadcom Corporation BCM47xx V.92 56k modem
[14e4:4712] (rev 01)

The device has no 56k modem, so i guess the pciutils database is wrong he=
re.

Regards, Manuel


--------------enig8CF86EE3A8C6C72BEE81A8F4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEUEARECAAYFAk51OE8ACgkQ+zov67K9xz5lfQCdHalWf+cRCXlMIGEeJonPLBcK
65MAmIt6gvEBseETKt8aSTTo2rqmljg=
=JLZV
-----END PGP SIGNATURE-----

--------------enig8CF86EE3A8C6C72BEE81A8F4--
