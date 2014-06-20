Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:17361 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934352AbaFTEjY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2014 00:39:24 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Chin-Ran Lo <crlo@marvell.com>, Xinming Hu <huxm@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 6/7] mwifiex: update Copyright to 2014
Date: Thu, 19 Jun 2014 21:38:57 -0700
Message-ID: <1403239138-3113-6-git-send-email-bzhao@marvell.com> (sfid-20140620_063931_196487_70B89DFE)
In-Reply-To: <1403239138-3113-1-git-send-email-bzhao@marvell.com>
References: <1403239138-3113-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch updates mwifiex Copyright to 2014.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11ac.c          | 2 +-
 drivers/net/wireless/mwifiex/11ac.h          | 2 +-
 drivers/net/wireless/mwifiex/11h.c           | 2 +-
 drivers/net/wireless/mwifiex/11n.c           | 2 +-
 drivers/net/wireless/mwifiex/11n.h           | 2 +-
 drivers/net/wireless/mwifiex/11n_aggr.c      | 2 +-
 drivers/net/wireless/mwifiex/11n_aggr.h      | 2 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c | 2 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.h | 2 +-
 drivers/net/wireless/mwifiex/Makefile        | 2 +-
 drivers/net/wireless/mwifiex/README          | 2 +-
 drivers/net/wireless/mwifiex/cfg80211.c      | 2 +-
 drivers/net/wireless/mwifiex/cfg80211.h      | 2 +-
 drivers/net/wireless/mwifiex/cfp.c           | 2 +-
 drivers/net/wireless/mwifiex/cmdevt.c        | 2 +-
 drivers/net/wireless/mwifiex/debugfs.c       | 2 +-
 drivers/net/wireless/mwifiex/decl.h          | 2 +-
 drivers/net/wireless/mwifiex/ethtool.c       | 2 +-
 drivers/net/wireless/mwifiex/fw.h            | 2 +-
 drivers/net/wireless/mwifiex/ie.c            | 2 +-
 drivers/net/wireless/mwifiex/init.c          | 2 +-
 drivers/net/wireless/mwifiex/ioctl.h         | 2 +-
 drivers/net/wireless/mwifiex/join.c          | 2 +-
 drivers/net/wireless/mwifiex/main.c          | 2 +-
 drivers/net/wireless/mwifiex/main.h          | 2 +-
 drivers/net/wireless/mwifiex/pcie.c          | 2 +-
 drivers/net/wireless/mwifiex/pcie.h          | 2 +-
 drivers/net/wireless/mwifiex/scan.c          | 2 +-
 drivers/net/wireless/mwifiex/sdio.c          | 2 +-
 drivers/net/wireless/mwifiex/sdio.h          | 2 +-
 drivers/net/wireless/mwifiex/sta_cmd.c       | 2 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c   | 2 +-
 drivers/net/wireless/mwifiex/sta_event.c     | 2 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c     | 2 +-
 drivers/net/wireless/mwifiex/sta_rx.c        | 2 +-
 drivers/net/wireless/mwifiex/sta_tx.c        | 2 +-
 drivers/net/wireless/mwifiex/txrx.c          | 2 +-
 drivers/net/wireless/mwifiex/uap_cmd.c       | 2 +-
 drivers/net/wireless/mwifiex/uap_event.c     | 2 +-
 drivers/net/wireless/mwifiex/uap_txrx.c      | 2 +-
 drivers/net/wireless/mwifiex/usb.c           | 2 +-
 drivers/net/wireless/mwifiex/usb.h           | 2 +-
 drivers/net/wireless/mwifiex/util.c          | 2 +-
 drivers/net/wireless/mwifiex/util.h          | 2 +-
 drivers/net/wireless/mwifiex/wmm.c           | 2 +-
 drivers/net/wireless/mwifiex/wmm.h           | 2 +-
 46 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11ac.c b/drivers/net/wireless/mwifiex/11ac.c
index 706831d..59d23fb 100644
--- a/drivers/net/wireless/mwifiex/11ac.c
+++ b/drivers/net/wireless/mwifiex/11ac.c
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: 802.11ac
  *
- * Copyright (C) 2013, Marvell International Ltd.
+ * Copyright (C) 2013-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/11ac.h b/drivers/net/wireless/mwifiex/11ac.h
index 0b02cb6..1ca92c7 100644
--- a/drivers/net/wireless/mwifiex/11ac.h
+++ b/drivers/net/wireless/mwifiex/11ac.h
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: 802.11ac
  *
- * Copyright (C) 2013, Marvell International Ltd.
+ * Copyright (C) 2013-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/11h.c b/drivers/net/wireless/mwifiex/11h.c
index e76b0db..2668e83 100644
--- a/drivers/net/wireless/mwifiex/11h.c
+++ b/drivers/net/wireless/mwifiex/11h.c
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: 802.11h
  *
- * Copyright (C) 2013, Marvell International Ltd.
+ * Copyright (C) 2013-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index e1c2f67..9d6d8d9 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: 802.11n
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 0b73fa0..2ee268b 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: 802.11n
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index 5b32106..b4c14b0 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: 802.11n Aggregation
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/11n_aggr.h b/drivers/net/wireless/mwifiex/11n_aggr.h
index 892098d..0cd2a3e 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.h
+++ b/drivers/net/wireless/mwifiex/11n_aggr.h
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: 802.11n Aggregation
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 0c3571f..b22bae3 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: 802.11n RX Re-ordering
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.h b/drivers/net/wireless/mwifiex/11n_rxreorder.h
index 0fc76e4..3a87bb0 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.h
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.h
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: 802.11n RX Re-ordering
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/Makefile b/drivers/net/wireless/mwifiex/Makefile
index 2aa208f..9487d72 100644
--- a/drivers/net/wireless/mwifiex/Makefile
+++ b/drivers/net/wireless/mwifiex/Makefile
@@ -1,5 +1,5 @@
 #
-# Copyright (C) 2011, Marvell International Ltd.
+# Copyright (C) 2011-2014, Marvell International Ltd.
 #
 # This software file (the "File") is distributed by Marvell International
 # Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/README b/drivers/net/wireless/mwifiex/README
index 831a98f..31928ca 100644
--- a/drivers/net/wireless/mwifiex/README
+++ b/drivers/net/wireless/mwifiex/README
@@ -1,4 +1,4 @@
-# Copyright (C) 2011, Marvell International Ltd.
+# Copyright (C) 2011-2014, Marvell International Ltd.
 #
 # This software file (the "File") is distributed by Marvell International
 # Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index e8981af..6ec2ee3 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: CFG80211
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/cfg80211.h b/drivers/net/wireless/mwifiex/cfg80211.h
index c584893..9083678 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.h
+++ b/drivers/net/wireless/mwifiex/cfg80211.h
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: CFG80211
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/cfp.c b/drivers/net/wireless/mwifiex/cfp.c
index 0ddec3d..b8242eb 100644
--- a/drivers/net/wireless/mwifiex/cfp.c
+++ b/drivers/net/wireless/mwifiex/cfp.c
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: Channel, Frequence and Power
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 421322f..606877b 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: commands and events
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 6a194a9..2713f7ac 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: debugfs
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 38da6ff..0e03fe3 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: generic data structures and APIs
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/ethtool.c b/drivers/net/wireless/mwifiex/ethtool.c
index 528bdfa..04e56b5 100644
--- a/drivers/net/wireless/mwifiex/ethtool.c
+++ b/drivers/net/wireless/mwifiex/ethtool.c
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: ethtool
  *
- * Copyright (C) 2013, Marvell International Ltd.
+ * Copyright (C) 2013-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 3175dd0..5561573 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: Firmware specific macros & structures
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/ie.c b/drivers/net/wireless/mwifiex/ie.c
index 3bf3d58..b933794 100644
--- a/drivers/net/wireless/mwifiex/ie.c
+++ b/drivers/net/wireless/mwifiex/ie.c
@@ -2,7 +2,7 @@
  * Marvell Wireless LAN device driver: management IE handling- setting and
  * deleting IE.
  *
- * Copyright (C) 2012, Marvell International Ltd.
+ * Copyright (C) 2012-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 2b68cf3..269a277 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: HW/FW Initialization
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 1b57672..0847f3e 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: ioctl data structures & APIs
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 89dc62a..fc13564 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: association and ad-hoc start/join
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 6bc645a..1261d9a 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: major functions
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 5e734f9..a2733b1 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: major data structures and prototypes
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index bf948fb..5f7afff 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: PCIE specific handling
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/pcie.h b/drivers/net/wireless/mwifiex/pcie.h
index ee073f5..a1a8fd3 100644
--- a/drivers/net/wireless/mwifiex/pcie.h
+++ b/drivers/net/wireless/mwifiex/pcie.h
@@ -3,7 +3,7 @@
  * @brief This file contains definitions for PCI-E interface.
  * driver.
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 45c5b34..dee717a 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: scan ioctl and command handling
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 95a1d1f..1da04a0 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: SDIO specific handling
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index e563309..6b8835e 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: SDIO specific definitions
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 88202ce..0f077aa 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: station command handling
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 577f297..822357b 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: station command response handling
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index f6395ef..f1c240e 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: station event handling
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 6b9395f..1a03d4d 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: functions for station ioctl
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index 8b639d7..9ceb1db 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: station RX data handling
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index 5fce7e7..cf330ba 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: station TX data handling
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index 37f26af..0820568 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: generic TX/RX data handling
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index 3264355..300bab4 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: AP specific command handling
  *
- * Copyright (C) 2012, Marvell International Ltd.
+ * Copyright (C) 2012-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
index 92e77a3..7c2b9766 100644
--- a/drivers/net/wireless/mwifiex/uap_event.c
+++ b/drivers/net/wireless/mwifiex/uap_event.c
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: AP event handling
  *
- * Copyright (C) 2012, Marvell International Ltd.
+ * Copyright (C) 2012-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/uap_txrx.c b/drivers/net/wireless/mwifiex/uap_txrx.c
index 9a56bc6..57fa47d 100644
--- a/drivers/net/wireless/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/mwifiex/uap_txrx.c
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: AP TX and RX data handling
  *
- * Copyright (C) 2012, Marvell International Ltd.
+ * Copyright (C) 2012-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index a8ce813..7118a18 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: USB specific handling
  *
- * Copyright (C) 2012, Marvell International Ltd.
+ * Copyright (C) 2012-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/usb.h b/drivers/net/wireless/mwifiex/usb.h
index 15b73d1..4c41c2a 100644
--- a/drivers/net/wireless/mwifiex/usb.h
+++ b/drivers/net/wireless/mwifiex/usb.h
@@ -1,7 +1,7 @@
 /*
  * This file contains definitions for mwifiex USB interface driver.
  *
- * Copyright (C) 2012, Marvell International Ltd.
+ * Copyright (C) 2012-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 6da5abf..cee0283 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: utility functions
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/util.h b/drivers/net/wireless/mwifiex/util.h
index caadb37..40296cb 100644
--- a/drivers/net/wireless/mwifiex/util.h
+++ b/drivers/net/wireless/mwifiex/util.h
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: utility functions
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index d3671d0..8cd123e 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: WMM
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
diff --git a/drivers/net/wireless/mwifiex/wmm.h b/drivers/net/wireless/mwifiex/wmm.h
index eca56e3..569bd73 100644
--- a/drivers/net/wireless/mwifiex/wmm.h
+++ b/drivers/net/wireless/mwifiex/wmm.h
@@ -1,7 +1,7 @@
 /*
  * Marvell Wireless LAN device driver: WMM
  *
- * Copyright (C) 2011, Marvell International Ltd.
+ * Copyright (C) 2011-2014, Marvell International Ltd.
  *
  * This software file (the "File") is distributed by Marvell International
  * Ltd. under the terms of the GNU General Public License Version 2, June 1991
-- 
1.8.2.3

