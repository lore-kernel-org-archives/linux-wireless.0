Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:55546 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992442AbXCGSWj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2007 13:22:39 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: John Linville <linville@tuxdriver.com>
Subject: mac80211-drivers pull request (week10)
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>,
	Andrea Merello <andrea.merello@gmail.com>
MIME-Version: 1.0
Date: Wed, 7 Mar 2007 13:21:50 -0500
Content-Type: multipart/signed;
  boundary="nextPart4831829.vGUzhaK8Q9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703071321.51267.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4831829.vGUzhaK8Q9
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi John,

Please pull
git://git.kernel.org/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
for these patches:

p54-week10 branch:
Michael Wu (2):
      p54usb: fix warnings on 64bit arch
      p54: Suppress warning in prism54common.c

rtl818x-week10 branch:
Andrea Merello (2):
      rtl8187: Minimize power consumption when down
      rtl8187: check IEEE80211_CONF_SHORT_SLOT_TIME

Michael Wu (1):
      rtl8187: Select EEPROM_93CX6

Common to all branches:
Helge Deller (1):
      p54/rtl818x/zd1211rw - various fixes

Michael Wu (1):
      adm8211, p54: select CRC32

Just some minor patches this time. There'll be more interesting things next=
=20
week..

Thanks,
=2DMichael Wu

--nextPart4831829.vGUzhaK8Q9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF7wK/T3Oqt9AH4aERAiXHAJ9xL2dfF9cv7DA3ynUh9UWRIHmzdgCgo6LO
uU4PSJiGWuwI9Bq6q9gFrSo=
=Ojsz
-----END PGP SIGNATURE-----

--nextPart4831829.vGUzhaK8Q9--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
