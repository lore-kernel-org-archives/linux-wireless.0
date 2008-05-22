Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60601 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974AbYEVQKk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 12:10:40 -0400
Received: from localhost (localhost [127.0.0.1])
	by hauke-m.de (Postfix) with ESMTP id B080D71808E
	for <linux-wireless@vger.kernel.org>; Thu, 22 May 2008 18:10:37 +0200 (CEST)
Received: from hauke-m.de ([127.0.0.1])
	by localhost (hauke-m.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nwl01C-XhrHd for <linux-wireless@vger.kernel.org>;
	Thu, 22 May 2008 18:10:30 +0200 (CEST)
Received: from [192.168.0.10] (unknown [91.97.240.189])
	by hauke-m.de (Postfix) with ESMTP id 4484371808C
	for <linux-wireless@vger.kernel.org>; Thu, 22 May 2008 18:10:26 +0200 (CEST)
Message-ID: <48359AF2.4070802@hauke-m.de> (sfid-20080522_181043_718751_7D2027FC)
Date: Thu, 22 May 2008 18:10:26 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: b43 lots of 43-phy0 ERROR: PHY transmission error
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFBD3A9A90EA958D58CD79A2B"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFBD3A9A90EA958D58CD79A2B
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I am using Ubuntu 8.04 for AMD64 with a vanilla kernel 2.6.25.3 and a
Broadcom Corporation BCM94311MCG wlan mini-PCI (rev 01) with firmware
version 410.2160 and the driver out of kernel 2.6.25.3.

When I am connected to some Access Points at University without wireless
encryption I get lots of error like this after some time (5 to 30 min):
[  182.179788] b43-phy0 ERROR: PHY transmission error
[  187.956923] printk: 28 messages suppressed.

With this error Network Manager says my connection is still up, but I
cant send data through the wireless LAN. The only way to get the
wireless LAN working again to rmmod b43 and insmod it again.
At some Access Points at University everything work fine and at home I
have no problems. With an earlier version of the b43 driver (~January
compat-wireless) I had no problems at the Access Points, that doesn't
work now.

These logs where taken at one place and I have rmmoded the driver some
times.
dmesg		http://www.hauke-m.de/fileadmin/b43/dmesg-2008-05-16
iwconfig	http://www.hauke-m.de/fileadmin/b43/iwconfig-2008-05-16
iwlist		http://www.hauke-m.de/fileadmin/b43/iwlist-2008-05-16

--
Hauke Mehrtens



--------------enigFBD3A9A90EA958D58CD79A2B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIVAwUBSDWa+oZ0px9YPRMyAQLzKw/+O6GsxfTEEA3AoxhWVvsHxVKCRhkWOV2r
9sfab2SKHFL2GR+qTAK7NUkgbS9WufgQ0L6q3h3+3qlSyTxrChdOI19YiG788rN1
bL6Jt16GKjBdA5P4aqOMr/4ey9YDylBxbUJ5hQRYma2edpzzTjkEweo9hE29/K8J
ya4RMk/Yl9i9I3WndTIk/AwUH9KKZHUZNy3hHx/J1byS6tPISCzoQxIvjdXfbKus
o/hWFO7IDnG754KbrHDoyXxPRrPvnLaCnsbgpnzlbsg17pyfF2frq1oLydPmyS+8
LH3eAqv5fEuMGUEju/Ylis42N7vn2r6UsJrJ+6/DQ05TrrT6WYdES0hDSDM028dy
BT+uw18LBSFE4MbYkWwVViYyn1OnNGLIeDgnOap1pRCZDxemoNs4Y8mBWxDnrg9+
LPp9flncF0bwVqjWJdcaIshQFe00GygG8ObqOfHR9ACraR1MUrCJnrl6ggmlnO/S
xFoiF7XZqD9pJo7lFUBuWOlWPlzdxi3lSynrwEJUevXLUaQP4i2J/lVUcRJhvFqj
OwPjc41h6fYUjqfQaJiYtioeMNOW81OAgD2TnWt4IB2OCO8VHY7dRQeO6nNFZGVZ
cdNczZs6vqnDjtNqrQndhNRAN4+4FAwqN5EDBqVyaBtxKh/Q7D3lPU0JHydSY/mm
SOMZrvydO6A=
=uiKO
-----END PGP SIGNATURE-----

--------------enigFBD3A9A90EA958D58CD79A2B--
