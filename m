Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:42671 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410Ab2KMR3J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 12:29:09 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so10386eaa.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2012 09:29:09 -0800 (PST)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: greg@kroah.com, Larry.Finger@lwfinger.net,
	linux-wireless@vger.kernel.org
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH 11/17] staging: rtl8187se: Removed non-existent function headers from r8180.h
Date: Tue, 13 Nov 2012 19:28:17 +0200
Message-Id: <1352827703-4659-12-git-send-email-maxtram95@gmail.com> (sfid-20121113_182922_024852_20A116DE)
In-Reply-To: <1352827703-4659-1-git-send-email-maxtram95@gmail.com>
References: <1352827703-4659-1-git-send-email-maxtram95@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleaned up r8180.h header file by removing headers of functions that
don't exist

Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
---
 drivers/staging/rtl8187se/r8180.h |   13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180.h b/drivers/staging/rtl8187se/r8180.h
index 2682afb..db7974a 100644
--- a/drivers/staging/rtl8187se/r8180.h
+++ b/drivers/staging/rtl8187se/r8180.h
@@ -667,35 +667,22 @@ void write_nic_dword(struct net_device *dev, int x,u32 y);
 void force_pci_posting(struct net_device *dev);
 
 void rtl8180_rtx_disable(struct net_device *);
-void rtl8180_rx_enable(struct net_device *);
-void rtl8180_tx_enable(struct net_device *);
-void rtl8180_start_scanning(struct net_device *dev);
-void rtl8180_start_scanning_s(struct net_device *dev);
-void rtl8180_stop_scanning(struct net_device *dev);
-void rtl8180_disassociate(struct net_device *dev);
-//void fix_rx_fifo(struct net_device *dev);
 void rtl8180_set_anaparam(struct net_device *dev,u32 a);
 void rtl8185_set_anaparam2(struct net_device *dev,u32 a);
 void rtl8180_set_hw_wep(struct net_device *dev);
 void rtl8180_no_hw_wep(struct net_device *dev);
 void rtl8180_update_msr(struct net_device *dev);
-//void rtl8180_BSS_create(struct net_device *dev);
 void rtl8180_beacon_tx_disable(struct net_device *dev);
 void rtl8180_beacon_rx_disable(struct net_device *dev);
-void rtl8180_conttx_enable(struct net_device *dev);
-void rtl8180_conttx_disable(struct net_device *dev);
 int rtl8180_down(struct net_device *dev);
 int rtl8180_up(struct net_device *dev);
 void rtl8180_commit(struct net_device *dev);
 void rtl8180_set_chan(struct net_device *dev,short ch);
-void rtl8180_set_master_essid(struct net_device *dev,char *essid);
-void rtl8180_update_beacon_security(struct net_device *dev);
 void write_phy(struct net_device *dev, u8 adr, u8 data);
 void write_phy_cck(struct net_device *dev, u8 adr, u32 data);
 void write_phy_ofdm(struct net_device *dev, u8 adr, u32 data);
 void rtl8185_tx_antenna(struct net_device *dev, u8 ant);
 void rtl8185_rf_pins_enable(struct net_device *dev);
-void IBSS_randomize_cell(struct net_device *dev);
 void IPSEnter(struct net_device *dev);
 void IPSLeave(struct net_device *dev);
 int get_curr_tx_free_desc(struct net_device *dev, int priority);
-- 
1.7.10.4

