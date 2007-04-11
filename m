Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:8777 "EHLO annwn14.rutgers.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752997AbXDKSmz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2007 14:42:55 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: John Linville <linville@tuxdriver.com>
Subject: mac80211-drivers pull request (week15)
Cc: linux-wireless@vger.kernel.org,
	Andrea Merello <andrea.merello@gmail.com>,
	Chr <chunkeey@web.de>, Daniel Drake <dsd@gentoo.org>,
	kune@deine-taler.de
MIME-Version: 1.0
Date: Wed, 11 Apr 2007 14:40:04 -0400
Content-Type: multipart/signed;
  boundary="nextPart5828059.tnBymJYrRX";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704111440.09728.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart5828059.tnBymJYrRX
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi John,

Please pull
git://git.kernel.org/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
for these patches:

Common to all branches:
Michael Wu (1):
      adm8211, p54, zd1211rw-mac80211, rtl8187: return -EOPNOTSUPP in=20
add_interface

adm8211-week15 branch:
Christian Lamparter (1):
      adm8211 remove some unnecessary IEEE80211_RATE_PREAMBLE2.

Michael Wu (1):
      adm8211: remove passive scan handler

p54-week15 branch:
Christian Lamparter (1):
      p54: more on retry count, rates and outputpower.

rtl818x-week15 branch:
Michael Wu (1):
      rtl8187: fix rtl818x_ioread* return types

zd1211rw-week15 branch:
Michael Wu (2):
      zd1211rw-mac80211: Enable monitor mode
      zd1211rw: Hide if zd1211rw-mac80211 is builtin

Thanks,
=2DMichael Wu

--nextPart5828059.tnBymJYrRX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGHSuJT3Oqt9AH4aERAlp5AKC/yu8VQsDJHHvv2P44XpJlZ7nclQCgjGSN
8dN2m3aQB8oeFqvu9voQFkI=
=FyPt
-----END PGP SIGNATURE-----

--nextPart5828059.tnBymJYrRX--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
