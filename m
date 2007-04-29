Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 84-16-245-18.internetserviceteam.com ([84.16.245.18]:54592 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161506AbXD2WHl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Apr 2007 18:07:41 -0400
Received: from localhost (localhost [127.0.0.1])
	by hauke-m.de (Postfix) with ESMTP id 0A356164D2
	for <linux-wireless@vger.kernel.org>; Mon, 30 Apr 2007 00:07:38 +0200 (CEST)
Received: from hauke-m.de ([84.16.245.18])
	by localhost (vs9007 [84.16.245.18]) (amavisd-new, port 10024)
	with ESMTP id 12753-04 for <linux-wireless@vger.kernel.org>;
	Mon, 30 Apr 2007 00:07:32 +0200 (CEST)
Received: from [192.168.0.2] (p5480A40F.dip0.t-ipconnect.de [84.128.164.15])
	by hauke-m.de (Postfix) with ESMTP id DC01F164D1
	for <linux-wireless@vger.kernel.org>; Mon, 30 Apr 2007 00:07:31 +0200 (CEST)
Message-ID: <46351724.8080902@hauke-m.de>
Date: Mon, 30 Apr 2007 00:07:32 +0200
From: Hauke Mehrtens <linux-wireless@hauke-m.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: warning in rtl8187_dev.c
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi

When I am compiling the rtl8187 driver I get this message:

drivers/net/wireless/mac80211/rtl818x/rtl8187_dev.c: In function
=E2=80=98rtl8187_probe=E2=80=99:
drivers/net/wireless/mac80211/rtl818x/rtl8187_dev.c:629: warning:
passing argument 3 of =E2=80=98eeprom_93cx6_multiread=E2=80=99 from inc=
ompatible pointer
type

It is mostly working, but it doesn't look nice. ;-)

- --
Hauke Mehrtens


Hauke Mehrtens
Westpreu=C3=9Fenweg 10
27442 Gnarrenburg
Tel.  : 04763/1745
Mobil : 0151/10778862
ICQ   : 160871207
Web   : www.hauke-m.de

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGNRckrcX0gpXFjnsRAtauAJ4z1TCv4GCRUrkmGX/eKPxQC7yjUwCfWeHE
PNHB/ZKJzWv8WcE8RWnY1SI=3D
=3D2r/1
-----END PGP SIGNATURE-----
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
