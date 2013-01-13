Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:62265 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876Ab3AMOWf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2013 09:22:35 -0500
Received: by mail-ee0-f52.google.com with SMTP id b15so1161302eek.11
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jan 2013 06:22:34 -0800 (PST)
Message-ID: <50F2C327.3040302@gmail.com> (sfid-20130113_152239_911408_B20DB105)
Date: Sun, 13 Jan 2013 15:22:31 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Subject: ath9k bugs
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

I see occasionally bugs with ath9k hardware.

ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
ath: phy0: Failed to stop TX DMA, queues=0x001!

kernel: 3.6.11-5.fc17.x86_64

device:
ieee80211 phy0: Atheros AR9280 Rev:2 mem=0xffffc900116c0000, irq=19
05:00.0 Network controller [0280]: Atheros Communications Inc. AR928X Wireless Network Adapter (PCI-Express) [168c:002a] (rev 01)


I also see the same bug with openwrt ATTITUDE ADJUSTMENT (12.09-rc1, r34185)
on a Buffalo WZR-HP-G300NH device:
https://dev.openwrt.org/ticket/9654

and "Rate marked as an HT rate but passed status->rate_idx is not an MCS index [0-76]: 77 (0x4d)"
https://dev.openwrt.org/ticket/12547

-thanks-
