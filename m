Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:65457 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab1BFSnU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Feb 2011 13:43:20 -0500
Date: Sun, 06 Feb 2011 12:44:10 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: sgruszka@redhat.com, george0505@realtek.com,
	chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH 0/6] rtlwifi: rtl8192ce: Patches to prepare for addition
 of rtl8192cu
Message-ID: <4d4eebfa.pwLpJWz5U4PCRqNL%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series of patches will prepare the rtlwifi core to receive the driver
for the RTL8192CU (USB) device, and to make some changes to the RTL8192CE
(PCI) code to facilitate the new driver.

1/6: Changes to rtlwifi core
2/6: Add usb driver to rtlwifi
3/6: Refactor rtl8192ce/dm.c to be able to use common code
4/6: Refactor rtl8192ce/fw.c to be able to use common code
5/6: Small changes to rtl8192ce/phy.c
6/6: Add some needed definitions to rtl8192ce/reg.h

All of these changes are for 2.6.39.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

