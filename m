Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:38029 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbbJQVG5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2015 17:06:57 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: paulmcquad@gmail.com
Cc: sgruszka@redhat.com, helmut.schaa@googlemail.com,
	kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] net: wireless: rt2x00: Space issue
Date: Sat, 17 Oct 2015 22:06:43 +0100
Message-Id: <1445116005-28670-1-git-send-email-paulmcquad@gmail.com> (sfid-20151017_230812_516376_DB2F51B0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removed empty spaces before/after parenthesis

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 3282ddb..6f8310a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -107,7 +107,7 @@
  * amount of bytes needed to move the data.
  */
 #define ALIGN_SIZE(__skb, __header) \
-	(  ((unsigned long)((__skb)->data + (__header))) & 3 )
+	(((unsigned long)((__skb)->data + (__header))) & 3)
 
 /*
  * Constants for extra TX headroom for alignment purposes.
@@ -128,14 +128,14 @@
 #define SLOT_TIME		20
 #define SHORT_SLOT_TIME		9
 #define SIFS			10
-#define PIFS			( SIFS + SLOT_TIME )
-#define SHORT_PIFS		( SIFS + SHORT_SLOT_TIME )
-#define DIFS			( PIFS + SLOT_TIME )
-#define SHORT_DIFS		( SHORT_PIFS + SHORT_SLOT_TIME )
-#define EIFS			( SIFS + DIFS + \
-				  GET_DURATION(IEEE80211_HEADER + ACK_SIZE, 10) )
-#define SHORT_EIFS		( SIFS + SHORT_DIFS + \
-				  GET_DURATION(IEEE80211_HEADER + ACK_SIZE, 10) )
+#define PIFS			(SIFS + SLOT_TIME)
+#define SHORT_PIFS		(SIFS + SHORT_SLOT_TIME)
+#define DIFS			(PIFS + SLOT_TIME)
+#define SHORT_DIFS		(SHORT_PIFS + SHORT_SLOT_TIME)
+#define EIFS			(SIFS + DIFS + \
+				  GET_DURATION(IEEE80211_HEADER + ACK_SIZE, 10))
+#define SHORT_EIFS		(SIFS + SHORT_DIFS + \
+				  GET_DURATION(IEEE80211_HEADER + ACK_SIZE, 10))
 
 enum rt2x00_chip_intf {
 	RT2X00_CHIP_INTF_PCI,

-- 
2.6.1

