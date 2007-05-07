Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:40528 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753289AbXEGHxP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2007 03:53:15 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: John Linville <linville@tuxdriver.com>
Subject: mac80211-drivers pull request (week18)
Cc: linux-wireless@vger.kernel.org,
	Andrea Merello <andrea.merello@gmail.com>,
	Stefano Brivio <stefano.brivio@polimi.it>
MIME-Version: 1.0
Date: Mon, 7 May 2007 03:52:39 -0400
Content-Type: multipart/signed;
  boundary="nextPart15308741.cnq8Wpm4Nl";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705070352.44018.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart15308741.cnq8Wpm4Nl
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi John,

Please pull
git://git.kernel.org/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
for these patches:

rtl818x-week18 branch:
Michael Wu (8):
      rtl818x: update register definitions
      rtl8187: use RTL818X_EEPROM_CMD_* everywhere
      rtl8187: improve printk messages
      rtl8187: set RTS duration
      rtl8187: remove software sequence number code
      rtl8187: eliminate warnings and improve reset code
      rtl8187: report correct RX rate
      rtl8187: avoid accessing skb->tail directly

Stefano Brivio (1):
      rtl818x-mac80211: fix coding style

Thanks,
-Michael Wu

--nextPart15308741.cnq8Wpm4Nl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGPtrLT3Oqt9AH4aERAjFnAJ96JenfPl4STR6R+L7bGew9tQnzdgCgnBLJ
9QeuTKoxeOPCkxxMVzXp8Z8=
=tx5g
-----END PGP SIGNATURE-----

--nextPart15308741.cnq8Wpm4Nl--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
