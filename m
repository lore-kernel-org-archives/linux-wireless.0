Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:10881 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754779AbXFJD1J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2007 23:27:09 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: John Linville <linville@tuxdriver.com>
Subject: mac80211-drivers pull request (week23)
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Date: Sat, 9 Jun 2007 20:26:22 -0700
Content-Type: multipart/signed;
  boundary="nextPart2077550.lF4ihCK24Q";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706092026.27045.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2077550.lF4ihCK24Q
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi John,

Please pull
git://git.kernel.org/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
for these patches:

adm8211-week23 branch:
Michael Wu (4):
      adm8211: remove unused field from adm8211_priv
      adm8211: replace mdelay with msleep
      adm8211: improve TX code
      adm8211: fix endianness issues

rtl818x-week23 branch:
Michael Wu (4):
      rtl8187: rename eeprom callbacks
      rtl8187: add defines for eeprom offsets
      rtl8187: convert writes to 0xFF85 into writes to RFPinsSelect
      rtl8187: fix short slot time configuration

Thanks,
-Michael Wu

--nextPart2077550.lF4ihCK24Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGa29jT3Oqt9AH4aERAgMcAJwM51xBydQBTo4hMFyHXXPcjRNV7wCfYmox
VYWk8Vr0o0hi23SydKMXjXw=
=JJHP
-----END PGP SIGNATURE-----

--nextPart2077550.lF4ihCK24Q--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
