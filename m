Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39666 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932394AbZJGMAL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 08:00:11 -0400
Content-Type: text/plain; charset="iso-8859-1"
Date: Wed, 07 Oct 2009 13:59:23 +0200
From: berndl81@gmx.at
Message-ID: <20091007115923.256060@gmx.net>
MIME-Version: 1.0
Subject: Bug: AR928x not working on 2.6.31.x
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am using Archlinux on my Acer Extensa 7630EZ and realize that my wireless-device which is an
 
Atheros Communications Inc. AR928X Wireless Network Adapter (PCI-Express) (rev 01)

according to lspci works very well using arch-stock kernel 2.6.30 and is not working any longer when using the 2.6.31.1 or 2.6.31.2 kernel from Arch's testing repository.

When using the 2.6.30 kernel (wlan is working very well), I get the following dmesg-output:
[bernhard@wallaby ~]$ dmesg |grep ath
ath9k 0000:05:00.0: enabling device (0000 -> 0002)
ath9k 0000:05:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
ath9k 0000:05:00.0: setting latency timer to 64
phy0: Selected rate control algorithm 'ath9k_rate_control'
Registered led device: ath9k-phy0::radio
Registered led device: ath9k-phy0::assoc
Registered led device: ath9k-phy0::tx
Registered led device: ath9k-phy0::rx

When upgrading to 2.6.31.x, i receive the following output:
[bernhard@wallaby ~]$ dmesg |grep ath
ath9k 0000:05:00.0: enabling device (0000 -> 0002)
ath9k 0000:05:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
ath9k 0000:05:00.0: setting latency timer to 64
ath9k 0000:05:00.0: PCI INT A disabled

As I see it, the device is recognized and instantly disabled again. The device cannot be brought up too using ifconfig.

I am quite clueless what do do aside from reporting the bug here as suggested in the original Arch-bugreport (http://bugs.archlinux.org/task/16413)

If any further information is helpful, I will of course happily try to provide it.

Bernhard
-- 
GRATIS für alle GMX-Mitglieder: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://portal.gmx.net/de/go/maxdome01
