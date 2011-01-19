Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57039 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025Ab1ASWfR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 17:35:17 -0500
Received: by mail-fx0-f46.google.com with SMTP id 20so1417828fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 14:35:17 -0800 (PST)
From: Jonas Gorski <jonas.gorski@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [RFT 3/8] staging: brcm80211: Remove unused ETHER_<foo> defines.
Date: Wed, 19 Jan 2011 23:35:27 +0100
Message-Id: <1295476532-21130-4-git-send-email-jonas.gorski@gmail.com>
In-Reply-To: <1295476532-21130-3-git-send-email-jonas.gorski@gmail.com>
References: <1295476532-21130-1-git-send-email-jonas.gorski@gmail.com>
 <1295476532-21130-2-git-send-email-jonas.gorski@gmail.com>
 <1295476532-21130-3-git-send-email-jonas.gorski@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
---
 drivers/staging/brcm80211/include/proto/ethernet.h |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/brcm80211/include/proto/ethernet.h b/drivers/staging/brcm80211/include/proto/ethernet.h
index af3b977..1176df9 100644
--- a/drivers/staging/brcm80211/include/proto/ethernet.h
+++ b/drivers/staging/brcm80211/include/proto/ethernet.h
@@ -21,19 +21,10 @@
 
 #include <packed_section_start.h>
 
-#define	ETHER_TYPE_LEN		2
-#define	ETHER_CRC_LEN		4
-#define	ETHER_MIN_LEN		64
-#define	ETHER_MIN_DATA		46
 #define	ETHER_MAX_LEN		1518
-#define	ETHER_MAX_DATA		1500
 
 #define	ETHER_TYPE_BRCM		0x886c
 
-#define ETHER_DEST_OFFSET	(0 * ETH_ALEN)
-#define ETHER_SRC_OFFSET	(1 * ETH_ALEN)
-#define ETHER_TYPE_OFFSET	(2 * ETH_ALEN)
-
 BWL_PRE_PACKED_STRUCT struct ether_addr {
 	u8 octet[ETH_ALEN];
 } BWL_POST_PACKED_STRUCT;
-- 
1.5.6.5

