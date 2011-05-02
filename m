Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58875 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab1EBDa5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 May 2011 23:30:57 -0400
Date: Sun, 01 May 2011 22:30:54 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Fix typo in pci.c
Message-ID: <4dbe256e.v9oxZywm8s+PAoUb%Larry.Finger@lwfinger.net> (sfid-20110502_053100_880902_3247D8E6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This fixes a typo in commit c7cfe38ee0f946415b0b, which will be in 2.6.40.

Larry
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/pci.c
@@ -1069,7 +1069,7 @@ static int _rtl_pci_init_tx_ring(struct
 
 	for (i = 0; i < entries; i++) {
 		nextdescaddress = (u32) dma +
-					      ((i + 11) % entries) *
+					      ((i + 1) % entries) *
 					      sizeof(*ring);
 
 		rtlpriv->cfg->ops->set_desc((u8 *)&(ring[i]),

