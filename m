Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:12373 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946403AbXBCIm3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Feb 2007 03:42:29 -0500
Received: from localhost (localhost.rutgers.edu [127.0.0.1])
	by annwn14.rutgers.edu (Postfix) with ESMTP id 17B756AD
	for <linux-wireless@vger.kernel.org>; Sat,  3 Feb 2007 03:03:38 -0500 (EST)
Received: from annwn14.rutgers.edu ([127.0.0.1])
	by localhost (annwn14.rutgers.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 05063-01 for <linux-wireless@vger.kernel.org>;
	Sat, 3 Feb 2007 03:03:38 -0500 (EST)
Received: from alpha.patmedia.net (host-24-225-148-91.patmedia.net [24.225.148.91])
	by annwn14.rutgers.edu (Postfix) with ESMTP id E8B046A5
	for <linux-wireless@vger.kernel.org>; Sat,  3 Feb 2007 03:03:37 -0500 (EST)
From: Michael Wu <flamingice@sourmilk.net>
To: linux-wireless@vger.kernel.org
Subject: d80211-drivers pull request (week05)
MIME-Version: 1.0
Date: Sat, 3 Feb 2007 03:03:04 -0500
Content-Type: multipart/signed;
  boundary="nextPart11479563.eXKnVQLTJI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702030303.09034.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart11479563.eXKnVQLTJI
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

[resend, forgot to CC linux-wireless]

Hi John,

Please pull
git://git.kernel.org/pub/scm/linux/kernel/git/mwu/d80211-drivers.git
for these patches:

adm8211-week05 branch:
Michael Wu (1):
      adm8211: set MAC address properly

p54-week05 branch:
Michael Wu (3):
      p54: set MAC address properly
      p54usb: silence warnings on BE
      p54pci: make work for big endian

zd1211rw-week05 branch:
Daniel Drake (3):
      zd1211rw-d80211: Generic HMAC initialization
      zd1211rw-d80211: Consistency for address space constants
      zd1211rw-d80211: Remove addressing abstraction

Maxime Austruy (1):
      zd1211rw-d80211: fix potential leak in usb_init

Michael Wu (1):
      zd1211rw-d80211: Support for multicast addresses

Ulrich Kunitz (2):
      zd1211rw-d80211: Fixed array size issue in reset_mode
      zd1211rw-d80211: Reset device in the probe call

Common to all branches:
Michael Wu (1):
      Remove unnecessary includes and SET_MODULE_OWNER

Patches ported from zd1211rw (softmac) now have the original author of the=
=20
patch set as the author in the commit when the "porting" was trivial.

Thanks,
=2DMichael Wu

--nextPart11479563.eXKnVQLTJI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBFxEG8T3Oqt9AH4aERAsM3AKDILmlU3Vnoxaan1MLo02ViD6AJQQCbB12B
WAo+2OFjl+WHFmO3N8WYLEA=
=zqMp
-----END PGP SIGNATURE-----

--nextPart11479563.eXKnVQLTJI--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
