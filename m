Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54241 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab0LHRVa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 12:21:30 -0500
Received: by pwj3 with SMTP id 3so324162pwj.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Dec 2010 09:21:29 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, chaoming_li@realsil.com.cn,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 00/22] rtl8192ce: Initial upload of driver
Date: Wed,  8 Dec 2010 11:12:30 -0600
Message-Id: <1291828372-25159-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch bomb contains a driver for Realtek RTL8192CE and RTL8188CE PCIe
devices. The firmware for this driver will be sent to linux-firmware.

[PATCH 01/22] rtl8192ce: Add files to rtlwifi - Part 1: core.{c,h}
[PATCH 02/22] rtl8192ce: Add files to rtlwifi - Part 2: base.{c,h}
[PATCH 03/22] rtl8192ce: Add files to rtlwifi - Part 3: cam.{c,h}
[PATCH 04/22] rtl8192ce: Add files to rtlwifi - Part 4: debug.{c,h}
[PATCH 05/22] rtl8192ce: Add files to rtlwifi - Part 5: efuse.{c,h}
[PATCH 06/22] rtl8192ce: Add files to rtlwifi - Part 6: pci.{c,h}
[PATCH 07/22] rtl8192ce: Add files to rtlwifi - Part 7: ps.{c,h}
[PATCH 08/22] rtl8192ce: Add files to rtlwifi - Part 8: rc.{c,h}
[PATCH 09/22] rtl8192ce: Add files to rtlwifi - Part 9: regd.{c,h}
[PATCH 10/22] rtl8192ce: Add files to rtlwifi - Part 10: wifi.h
[PATCH 11/22] rtl8192ce: Add files to rtlwifi - Part 11: Kconfig and Makefile
[PATCH 12/22] rtl8192ce: Add files to rtlwifi/rtl8192ce - Part 12: rtl8192c-dm.{c,h}
[PATCH 13/22] rtl8192ce: Add files to rtlwifi/rtl8192ce - Part 13: rtl8192c-fw.{c,h}
[PATCH 14/22] rtl8192ce: Add files to rtlwifi/rtl8192ce - Part 14: rtl8192c-hw.{c,h}
[PATCH 15/22] rtl8192ce: Add files to rtlwifi/rtl8192ce - Part 15: rtl8192c-led.{c,h}
[PATCH 16/22] rtl8192ce: Add files to rtlwifi/rtl8192ce - Part 16: rtl8192c-phy.{c,h}
[PATCH 17/22] rtl8192ce: Add files to rtlwifi/rtl8192ce - Part 17: rtl8192c-sw.{c,h}
[PATCH 18/22] rtl8192ce: Add files to rtlwifi/rtl8192ce - Part 18: rtl8192c-rf.{c,h}
[PATCH 19/22] rtl8192ce: Add files to rtlwifi/rtl8192ce - Part 19: rtl8192c-table.{c,h}
[PATCH 20/22] rtl8192ce: Add files to rtlwifi/rtl8192ce - Part 20: rtl8192c-trx.{c,h}
[PATCH 21/22] rtl8192ce: Add files to rtlwifi/rtl8192ce - Part 21: rtl8192c-def.h,
[PATCH 22/22] rtl8192ce: Part 22: Update drivers/net/wireless/Kconfig and Makefile

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This driver is intended for wireless-testing and kernel 2.6.38. You can pull it
from git://git.kernel.org/pub/scm/linux/kernel/git/lwfinger/rtl8192ce.git.

Thanks,

Larry

