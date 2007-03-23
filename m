Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:46936 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422859AbXCWMyJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 08:54:09 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: John Linville <linville@tuxdriver.com>
Subject: mac80211-drivers pull request (week12)
Cc: linux-wireless@vger.kernel.org,
	Andrea Merello <andrea.merello@gmail.com>,
	Chr <chunkeey@web.de>
MIME-Version: 1.0
Date: Fri, 23 Mar 2007 08:52:54 -0400
Content-Type: multipart/signed;
  boundary="nextPart1956126.FCsk95MfAM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703230852.55259.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1956126.FCsk95MfAM
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi John,

Please pull
git://git.kernel.org/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
for these patches:

p54-week10 branch:
Christian Lamparter (1):
      p54: fix rates and add short preambles support for cck

Michael Wu (3):
      p54usb: Move USB ID entry to v2 section
      p54pci: Fix error path when eeprom read fails
      p54: Add RTS/CTS support

rtl818x-week10 branch:
Michael Wu (2):
      rtl8187: Enable contention window
      rtl8187: Set MSR

Thanks,
-Michael Wu

--nextPart1956126.FCsk95MfAM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGA82nT3Oqt9AH4aERAk79AJ9h8q+56r34AN2SNPIHLX4BbZWNggCfVP74
vSFNUcD0EJYan1Hrcsz02Pg=
=mlXs
-----END PGP SIGNATURE-----

--nextPart1956126.FCsk95MfAM--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
