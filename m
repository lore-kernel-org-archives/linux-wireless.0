Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56386 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757749Ab1BKU1q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Feb 2011 15:27:46 -0500
Date: Fri, 11 Feb 2011 14:27:43 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: sgruszka@redhat.com, george0505@realtek.com,
	chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH 0/5] rtlwifi: rtl8192ce: Patches to prepare for addition
 of rtl8192cu
Message-ID: <4d559bbf.GVswEooEZC6lIahx%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series of patches will prepare the rtlwifi core to receive the driver
for the RTL8192CU (USB) device, and to make some changes to the RTL8192CE
(PCI) code to facilitate the new driver.

1/5: Changes to rtlwifi core
2/5: Add usb driver to rtlwifi
3/5: Refactor rtl8192ce/dm.c to be able to use common code
4/5: Refactor rtl8192ce/fw.c to be able to use common code
5/5: Small changes to rtl8192ce/phy.c

All of these changes are for 2.6.39.

V2 addresses all comments from V1.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

