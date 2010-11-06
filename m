Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33441 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab0KFOtj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Nov 2010 10:49:39 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so2216256eye.19
        for <linux-wireless@vger.kernel.org>; Sat, 06 Nov 2010 07:49:38 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 04/18] rt2x00: checkpatch.pl error fixes for rt2800.h
Date: Sat, 6 Nov 2010 15:44:52 +0100
Cc: linux-wireless@vger.kernel.org
References: <201011061544.00876.IvDoorn@gmail.com> <201011061544.16363.IvDoorn@gmail.com> <201011061544.33907.IvDoorn@gmail.com>
In-Reply-To: <201011061544.33907.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011061544.52879.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mark Einon <mark.einon@gmail.com>

rt2800.h:1511: ERROR: space prohibited after that open parenthesis '('
rt2800.h:1511: ERROR: space prohibited before that close parenthesis ')'
rt2800.h:1513: ERROR: space prohibited after that open parenthesis '('
rt2800.h:1513: ERROR: space prohibited before that close parenthesis ')'
rt2800.h:1515: ERROR: space prohibited after that open parenthesis '('
rt2800.h:1515: ERROR: space prohibited before that close parenthesis ')'
rt2800.h:1517: ERROR: space prohibited after that open parenthesis '('
rt2800.h:1517: ERROR: space prohibited before that close parenthesis ')'
rt2800.h:1519: ERROR: space prohibited after that open parenthesis '('
rt2800.h:1519: ERROR: space prohibited before that close parenthesis ')'
rt2800.h:1521: ERROR: space prohibited after that open parenthesis '('
rt2800.h:1521: ERROR: space prohibited before that close parenthesis ')'
rt2800.h:1661: ERROR: space prohibited after that open parenthesis '('
rt2800.h:1661: ERROR: space prohibited before that close parenthesis ')'
rt2800.h:1662: ERROR: space prohibited after that open parenthesis '('
rt2800.h:1662: ERROR: space prohibited before that close parenthesis ')'
rt2800.h:1663: ERROR: space prohibited before that close parenthesis ')'
rt2800.h:2013: ERROR: space prohibited after that open parenthesis '('
rt2800.h:2013: ERROR: space prohibited before that close parenthesis ')'
rt2800.h:2014: ERROR: space prohibited after that open parenthesis '('
rt2800.h:2014: ERROR: space prohibited before that close parenthesis ')'

Signed-off-by: Mark Einon <mark.einon@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 6cfed06..c2cc126 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -1508,17 +1508,17 @@
 #define SHARED_KEY_MODE_BASE		0x7000
 
 #define MAC_WCID_ENTRY(__idx) \
-	( MAC_WCID_BASE + ((__idx) * sizeof(struct mac_wcid_entry)) )
+	(MAC_WCID_BASE + ((__idx) * sizeof(struct mac_wcid_entry)))
 #define PAIRWISE_KEY_ENTRY(__idx) \
-	( PAIRWISE_KEY_TABLE_BASE + ((__idx) * sizeof(struct hw_key_entry)) )
+	(PAIRWISE_KEY_TABLE_BASE + ((__idx) * sizeof(struct hw_key_entry)))
 #define MAC_IVEIV_ENTRY(__idx) \
-	( MAC_IVEIV_TABLE_BASE + ((__idx) * sizeof(struct mac_iveiv_entry)) )
+	(MAC_IVEIV_TABLE_BASE + ((__idx) * sizeof(struct mac_iveiv_entry)))
 #define MAC_WCID_ATTR_ENTRY(__idx) \
-	( MAC_WCID_ATTRIBUTE_BASE + ((__idx) * sizeof(u32)) )
+	(MAC_WCID_ATTRIBUTE_BASE + ((__idx) * sizeof(u32)))
 #define SHARED_KEY_ENTRY(__idx) \
-	( SHARED_KEY_TABLE_BASE + ((__idx) * sizeof(struct hw_key_entry)) )
+	(SHARED_KEY_TABLE_BASE + ((__idx) * sizeof(struct hw_key_entry)))
 #define SHARED_KEY_MODE_ENTRY(__idx) \
-	( SHARED_KEY_MODE_BASE + ((__idx) * sizeof(u32)) )
+	(SHARED_KEY_MODE_BASE + ((__idx) * sizeof(u32)))
 
 struct mac_wcid_entry {
 	u8 mac[6];
@@ -1658,9 +1658,9 @@ struct mac_iveiv_entry {
 #define HW_BEACON_BASE7			0x5bc0
 
 #define HW_BEACON_OFFSET(__index) \
-	( ((__index) < 4) ? ( HW_BEACON_BASE0 + (__index * 0x0200) ) : \
-	  (((__index) < 6) ? ( HW_BEACON_BASE4 + ((__index - 4) * 0x0200) ) : \
-	  (HW_BEACON_BASE6 - ((__index - 6) * 0x0200))) )
+	(((__index) < 4) ? (HW_BEACON_BASE0 + (__index * 0x0200)) : \
+	  (((__index) < 6) ? (HW_BEACON_BASE4 + ((__index - 4) * 0x0200)) : \
+	  (HW_BEACON_BASE6 - ((__index - 6) * 0x0200))))
 
 /*
  * BBP registers.
@@ -2010,8 +2010,8 @@ struct mac_iveiv_entry {
 /*
  * DMA descriptor defines.
  */
-#define TXWI_DESC_SIZE			( 4 * sizeof(__le32) )
-#define RXWI_DESC_SIZE			( 4 * sizeof(__le32) )
+#define TXWI_DESC_SIZE			(4 * sizeof(__le32))
+#define RXWI_DESC_SIZE			(4 * sizeof(__le32))
 
 /*
  * TX WI structure
-- 
1.7.2.3

