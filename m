Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:52078 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbZCFOci (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 09:32:38 -0500
Received: by fxm24 with SMTP id 24so402680fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 06 Mar 2009 06:32:35 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linville@tuxdriver.com
Subject: [PATCH 1/3] ipw2x00: remove duplicated defines
Date: Fri, 6 Mar 2009 15:32:20 +0100
Cc: linux-wireless@vger.kernel.org, yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200903061532.22200.helmut.schaa@gmail.com> (sfid-20090306_153241_650180_FF919A37)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove several duplicated defines from ipw2x00/ieee80211.h which are
also available in linux/ieee80211.h.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

diff --git a/drivers/net/wireless/ipw2x00/ieee80211.h b/drivers/net/wireless/ipw2x00/ieee80211.h
index 97c7cfc..e292114 100644
--- a/drivers/net/wireless/ipw2x00/ieee80211.h
+++ b/drivers/net/wireless/ipw2x00/ieee80211.h
@@ -54,59 +54,6 @@
 #define MIN_FRAG_THRESHOLD     256U
 #define	MAX_FRAG_THRESHOLD     2346U
 
-/* Frame control field constants */
-#define IEEE80211_FCTL_VERS		0x0003
-#define IEEE80211_FCTL_FTYPE		0x000c
-#define IEEE80211_FCTL_STYPE		0x00f0
-#define IEEE80211_FCTL_TODS		0x0100
-#define IEEE80211_FCTL_FROMDS		0x0200
-#define IEEE80211_FCTL_MOREFRAGS	0x0400
-#define IEEE80211_FCTL_RETRY		0x0800
-#define IEEE80211_FCTL_PM		0x1000
-#define IEEE80211_FCTL_MOREDATA		0x2000
-#define IEEE80211_FCTL_PROTECTED	0x4000
-#define IEEE80211_FCTL_ORDER		0x8000
-
-#define IEEE80211_FTYPE_MGMT		0x0000
-#define IEEE80211_FTYPE_CTL		0x0004
-#define IEEE80211_FTYPE_DATA		0x0008
-
-/* management */
-#define IEEE80211_STYPE_ASSOC_REQ	0x0000
-#define IEEE80211_STYPE_ASSOC_RESP 	0x0010
-#define IEEE80211_STYPE_REASSOC_REQ	0x0020
-#define IEEE80211_STYPE_REASSOC_RESP	0x0030
-#define IEEE80211_STYPE_PROBE_REQ	0x0040
-#define IEEE80211_STYPE_PROBE_RESP	0x0050
-#define IEEE80211_STYPE_BEACON		0x0080
-#define IEEE80211_STYPE_ATIM		0x0090
-#define IEEE80211_STYPE_DISASSOC	0x00A0
-#define IEEE80211_STYPE_AUTH		0x00B0
-#define IEEE80211_STYPE_DEAUTH		0x00C0
-#define IEEE80211_STYPE_ACTION		0x00D0
-
-/* control */
-#define IEEE80211_STYPE_PSPOLL		0x00A0
-#define IEEE80211_STYPE_RTS		0x00B0
-#define IEEE80211_STYPE_CTS		0x00C0
-#define IEEE80211_STYPE_ACK		0x00D0
-#define IEEE80211_STYPE_CFEND		0x00E0
-#define IEEE80211_STYPE_CFENDACK	0x00F0
-
-/* data */
-#define IEEE80211_STYPE_DATA		0x0000
-#define IEEE80211_STYPE_DATA_CFACK	0x0010
-#define IEEE80211_STYPE_DATA_CFPOLL	0x0020
-#define IEEE80211_STYPE_DATA_CFACKPOLL	0x0030
-#define IEEE80211_STYPE_NULLFUNC	0x0040
-#define IEEE80211_STYPE_CFACK		0x0050
-#define IEEE80211_STYPE_CFPOLL		0x0060
-#define IEEE80211_STYPE_CFACKPOLL	0x0070
-#define IEEE80211_STYPE_QOS_DATA        0x0080
-
-#define IEEE80211_SCTL_FRAG		0x000F
-#define IEEE80211_SCTL_SEQ		0xFFF0
-
 /* QOS control */
 #define IEEE80211_QCTL_TID		0x000F
