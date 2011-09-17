Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s2.udvp.de ([188.40.48.165]:35458 "EHLO s2.udvp.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754355Ab1IQVtz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Sep 2011 17:49:55 -0400
Received: from [192.168.0.30] (agsb-4d055210.pool.mediaWays.net [77.5.82.16])
	by s2.udvp.de (Postfix) with ESMTPA id 72BC228C0CC
	for <linux-wireless@vger.kernel.org>; Sat, 17 Sep 2011 23:44:02 +0200 (CEST)
Message-ID: <4E751496.30903@somakoma.de> (sfid-20110917_235004_422488_60534D2C)
Date: Sat, 17 Sep 2011 23:43:50 +0200
From: Manuel Munz <freifunk@somakoma.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: No beacons in ad-hoc mode with b43
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig55163B27DBAA104E834586C7"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig55163B27DBAA104E834586C7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

i want to use b43 on older broadcom wireless routers with openwrt, but
there seems to be a problem: The router doesn't send beacons in adhoc
mode (verified with wireshark), which means users can't see the network
in a network scan. So is there a problem in the adhoc implementation
with b43? Could someone please have a look at this? It is preventing us
from using b43 in our mesh for too long now.

Some Infos about hardware/software used:

Router:
Siemens SE505 (very similar to wrt54g), Broadcom 4712 WLAN (core revision=
 7)

Software:
Openwrt Backfire r28226
kmod-b43 - 2.6.32.27+2011-08-26-1
kmod-b43legacy - 2.6.32.27+2011-08-26-1
kmod-cfg80211 - 2.6.32.27+2011-08-26-1
kmod-mac80211 - 2.6.32.27+2011-08-26-1

Kind regards, Manuel


--------------enig55163B27DBAA104E834586C7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk51FJYACgkQ+zov67K9xz6JSgCfcELi/BvPNgDQNgMYCFKudTbX
GgQAmwfNBGBRU23Yrev6zxiuSXNmbX/o
=QX0m
-----END PGP SIGNATURE-----

--------------enig55163B27DBAA104E834586C7--
