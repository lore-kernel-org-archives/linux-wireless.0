Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:58506 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757238AbZKWVpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 16:45:09 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH v2 5/8] rt2x00: Whitespace cleanup.
Date: Mon, 23 Nov 2009 22:44:51 +0100
Message-Id: <1259012694-14869-6-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1259012694-14869-5-git-send-email-gwingerde@gmail.com>
References: <1259012694-14869-1-git-send-email-gwingerde@gmail.com>
 <1259012694-14869-2-git-send-email-gwingerde@gmail.com>
 <1259012694-14869-3-git-send-email-gwingerde@gmail.com>
 <1259012694-14869-4-git-send-email-gwingerde@gmail.com>
 <1259012694-14869-5-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Clean up the use of whitespace in the initialization of the rt2x00_ops
structures. This is preparatory for a later patch that adds members
to that structure, which require different whitespace alignment.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |   26 +++++++++++++-------------
 drivers/net/wireless/rt2x00/rt2500pci.c |   26 +++++++++++++-------------
 drivers/net/wireless/rt2x00/rt2500usb.c |   26 +++++++++++++-------------
 drivers/net/wireless/rt2x00/rt2800pci.c |   24 ++++++++++++------------
 drivers/net/wireless/rt2x00/rt2800usb.c |   24 ++++++++++++------------
 drivers/net/wireless/rt2x00/rt61pci.c   |   24 ++++++++++++------------
 drivers/net/wireless/rt2x00/rt73usb.c   |   24 ++++++++++++------------
 7 files changed, 87 insertions(+), 87 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 6e68bc7..7f900be 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1623,20 +1623,20 @@ static const struct data_queue_desc rt2400pci_queue_atim = {
 };
 
 static const struct rt2x00_ops rt2400pci_ops = {
-	.name		= KBUILD_MODNAME,
-	.max_sta_intf	= 1,
-	.max_ap_intf	= 1,
-	.eeprom_size	= EEPROM_SIZE,
-	.rf_size	= RF_SIZE,
-	.tx_queues	= NUM_TX_QUEUES,
-	.rx		= &rt2400pci_queue_rx,
-	.tx		= &rt2400pci_queue_tx,
-	.bcn		= &rt2400pci_queue_bcn,
-	.atim		= &rt2400pci_queue_atim,
-	.lib		= &rt2400pci_rt2x00_ops,
-	.hw		= &rt2400pci_mac80211_ops,
+	.name			= KBUILD_MODNAME,
+	.max_sta_intf		= 1,
+	.max_ap_intf		= 1,
+	.eeprom_size		= EEPROM_SIZE,
+	.rf_size		= RF_SIZE,
+	.tx_queues		= NUM_TX_QUEUES,
+	.rx			= &rt2400pci_queue_rx,
+	.tx			= &rt2400pci_queue_tx,
+	.bcn			= &rt2400pci_queue_bcn,
+	.atim			= &rt2400pci_queue_atim,
+	.lib			= &rt2400pci_rt2x00_ops,
+	.hw			= &rt2400pci_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-	.debugfs	= &rt2400pci_rt2x00debug,
+	.debugfs		= &rt2400pci_rt2x00debug,
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 9a31e5e..30960fd 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1922,20 +1922,20 @@ static const struct data_queue_desc rt2500pci_queue_atim = {
 };
 
 static const struct rt2x00_ops rt2500pci_ops = {
-	.name		= KBUILD_MODNAME,
-	.max_sta_intf	= 1,
-	.max_ap_intf	= 1,
-	.eeprom_size	= EEPROM_SIZE,
-	.rf_size	= RF_SIZE,
-	.tx_queues	= NUM_TX_QUEUES,
-	.rx		= &rt2500pci_queue_rx,
-	.tx		= &rt2500pci_queue_tx,
-	.bcn		= &rt2500pci_queue_bcn,
-	.atim		= &rt2500pci_queue_atim,
-	.lib		= &rt2500pci_rt2x00_ops,
-	.hw		= &rt2500pci_mac80211_ops,
+	.name			= KBUILD_MODNAME,
+	.max_sta_intf		= 1,
+	.max_ap_intf		= 1,
+	.eeprom_size		= EEPROM_SIZE,
+	.rf_size		= RF_SIZE,
+	.tx_queues		= NUM_TX_QUEUES,
+	.rx			= &rt2500pci_queue_rx,
+	.tx			= &rt2500pci_queue_tx,
+	.bcn			= &rt2500pci_queue_bcn,
+	.atim			= &rt2500pci_queue_atim,
+	.lib			= &rt2500pci_rt2x00_ops,
+	.hw			= &rt2500pci_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-	.debugfs	= &rt2500pci_rt2x00debug,
+	.debugfs		= &rt2500pci_rt2x00debug,
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index b2de43e..02290f6 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1823,20 +1823,20 @@ static const struct data_queue_desc rt2500usb_queue_atim = {
 };
 
 static const struct rt2x00_ops rt2500usb_ops = {
-	.name		= KBUILD_MODNAME,
-	.max_sta_intf	= 1,
-	.max_ap_intf	= 1,
-	.eeprom_size	= EEPROM_SIZE,
-	.rf_size	= RF_SIZE,
-	.tx_queues	= NUM_TX_QUEUES,
-	.rx		= &rt2500usb_queue_rx,
-	.tx		= &rt2500usb_queue_tx,
-	.bcn		= &rt2500usb_queue_bcn,
-	.atim		= &rt2500usb_queue_atim,
-	.lib		= &rt2500usb_rt2x00_ops,
-	.hw		= &rt2500usb_mac80211_ops,
+	.name			= KBUILD_MODNAME,
+	.max_sta_intf		= 1,
+	.max_ap_intf		= 1,
+	.eeprom_size		= EEPROM_SIZE,
+	.rf_size		= RF_SIZE,
+	.tx_queues		= NUM_TX_QUEUES,
+	.rx			= &rt2500usb_queue_rx,
+	.tx			= &rt2500usb_queue_tx,
+	.bcn			= &rt2500usb_queue_bcn,
+	.atim			= &rt2500usb_queue_atim,
+	.lib			= &rt2500usb_rt2x00_ops,
+	.hw			= &rt2500usb_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-	.debugfs	= &rt2500usb_rt2x00debug,
+	.debugfs		= &rt2500usb_rt2x00debug,
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 87a5094..029a45f 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1201,19 +1201,19 @@ static const struct data_queue_desc rt2800pci_queue_bcn = {
 };
 
 static const struct rt2x00_ops rt2800pci_ops = {
-	.name		= KBUILD_MODNAME,
-	.max_sta_intf	= 1,
-	.max_ap_intf	= 8,
-	.eeprom_size	= EEPROM_SIZE,
-	.rf_size	= RF_SIZE,
-	.tx_queues	= NUM_TX_QUEUES,
-	.rx		= &rt2800pci_queue_rx,
-	.tx		= &rt2800pci_queue_tx,
-	.bcn		= &rt2800pci_queue_bcn,
-	.lib		= &rt2800pci_rt2x00_ops,
-	.hw		= &rt2800_mac80211_ops,
+	.name			= KBUILD_MODNAME,
+	.max_sta_intf		= 1,
+	.max_ap_intf		= 8,
+	.eeprom_size		= EEPROM_SIZE,
+	.rf_size		= RF_SIZE,
+	.tx_queues		= NUM_TX_QUEUES,
+	.rx			= &rt2800pci_queue_rx,
+	.tx			= &rt2800pci_queue_tx,
+	.bcn			= &rt2800pci_queue_bcn,
+	.lib			= &rt2800pci_rt2x00_ops,
+	.hw			= &rt2800_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-	.debugfs	= &rt2800_rt2x00debug,
+	.debugfs		= &rt2800_rt2x00debug,
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 9ab15c4..208316a 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -790,19 +790,19 @@ static const struct data_queue_desc rt2800usb_queue_bcn = {
 };
 
 static const struct rt2x00_ops rt2800usb_ops = {
-	.name		= KBUILD_MODNAME,
-	.max_sta_intf	= 1,
-	.max_ap_intf	= 8,
-	.eeprom_size	= EEPROM_SIZE,
-	.rf_size	= RF_SIZE,
-	.tx_queues	= NUM_TX_QUEUES,
-	.rx		= &rt2800usb_queue_rx,
-	.tx		= &rt2800usb_queue_tx,
-	.bcn		= &rt2800usb_queue_bcn,
-	.lib		= &rt2800usb_rt2x00_ops,
-	.hw		= &rt2800_mac80211_ops,
+	.name			= KBUILD_MODNAME,
+	.max_sta_intf		= 1,
+	.max_ap_intf		= 8,
+	.eeprom_size		= EEPROM_SIZE,
+	.rf_size		= RF_SIZE,
+	.tx_queues		= NUM_TX_QUEUES,
+	.rx			= &rt2800usb_queue_rx,
+	.tx			= &rt2800usb_queue_tx,
+	.bcn			= &rt2800usb_queue_bcn,
+	.lib			= &rt2800usb_rt2x00_ops,
+	.hw			= &rt2800_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-	.debugfs	= &rt2800_rt2x00debug,
+	.debugfs		= &rt2800_rt2x00debug,
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index bf04605..4cb9afe 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2788,19 +2788,19 @@ static const struct data_queue_desc rt61pci_queue_bcn = {
 };
 
 static const struct rt2x00_ops rt61pci_ops = {
-	.name		= KBUILD_MODNAME,
-	.max_sta_intf	= 1,
-	.max_ap_intf	= 4,
-	.eeprom_size	= EEPROM_SIZE,
-	.rf_size	= RF_SIZE,
-	.tx_queues	= NUM_TX_QUEUES,
-	.rx		= &rt61pci_queue_rx,
-	.tx		= &rt61pci_queue_tx,
-	.bcn		= &rt61pci_queue_bcn,
-	.lib		= &rt61pci_rt2x00_ops,
-	.hw		= &rt61pci_mac80211_ops,
+	.name			= KBUILD_MODNAME,
+	.max_sta_intf		= 1,
+	.max_ap_intf		= 4,
+	.eeprom_size		= EEPROM_SIZE,
+	.rf_size		= RF_SIZE,
+	.tx_queues		= NUM_TX_QUEUES,
+	.rx			= &rt61pci_queue_rx,
+	.tx			= &rt61pci_queue_tx,
+	.bcn			= &rt61pci_queue_bcn,
+	.lib			= &rt61pci_rt2x00_ops,
+	.hw			= &rt61pci_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-	.debugfs	= &rt61pci_rt2x00debug,
+	.debugfs		= &rt61pci_rt2x00debug,
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 5bbcf66..d13a051 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2306,19 +2306,19 @@ static const struct data_queue_desc rt73usb_queue_bcn = {
 };
 
 static const struct rt2x00_ops rt73usb_ops = {
-	.name		= KBUILD_MODNAME,
-	.max_sta_intf	= 1,
-	.max_ap_intf	= 4,
-	.eeprom_size	= EEPROM_SIZE,
-	.rf_size	= RF_SIZE,
-	.tx_queues	= NUM_TX_QUEUES,
-	.rx		= &rt73usb_queue_rx,
-	.tx		= &rt73usb_queue_tx,
-	.bcn		= &rt73usb_queue_bcn,
-	.lib		= &rt73usb_rt2x00_ops,
-	.hw		= &rt73usb_mac80211_ops,
+	.name			= KBUILD_MODNAME,
+	.max_sta_intf		= 1,
+	.max_ap_intf		= 4,
+	.eeprom_size		= EEPROM_SIZE,
+	.rf_size		= RF_SIZE,
+	.tx_queues		= NUM_TX_QUEUES,
+	.rx			= &rt73usb_queue_rx,
+	.tx			= &rt73usb_queue_tx,
+	.bcn			= &rt73usb_queue_bcn,
+	.lib			= &rt73usb_rt2x00_ops,
+	.hw			= &rt73usb_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-	.debugfs	= &rt73usb_rt2x00debug,
+	.debugfs		= &rt73usb_rt2x00debug,
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 };
 
-- 
1.6.5.3

