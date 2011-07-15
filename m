Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:9651 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab1GOXGl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 19:06:41 -0400
Subject: [PATCH 3/4] ath9k: remove defines in reg.h that exist in ../reg.h
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Fri, 15 Jul 2011 19:06:40 -0400
Message-ID: <20110715230640.4461.34448.stgit@mj.roinet.com> (sfid-20110716_010644_511424_83697D78)
In-Reply-To: <20110715230627.4461.85730.stgit@mj.roinet.com>
References: <20110715230627.4461.85730.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath9k/reg.h |   23 -----------------------
 1 files changed, 0 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 759b72c..fa4c0bb 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1873,29 +1873,6 @@ enum {
 #define AR_RATE_DURATION(_n)    (AR_RATE_DURATION_0 + ((_n)<<2))
 
 
-#define AR_KEYTABLE_0           0x8800
-#define AR_KEYTABLE(_n)         (AR_KEYTABLE_0 + ((_n)*32))
-#define AR_KEY_CACHE_SIZE       128
-#define AR_RSVD_KEYTABLE_ENTRIES 4
-#define AR_KEY_TYPE             0x00000007
-#define AR_KEYTABLE_TYPE_40     0x00000000
-#define AR_KEYTABLE_TYPE_104    0x00000001
-#define AR_KEYTABLE_TYPE_128    0x00000003
-#define AR_KEYTABLE_TYPE_TKIP   0x00000004
-#define AR_KEYTABLE_TYPE_AES    0x00000005
-#define AR_KEYTABLE_TYPE_CCM    0x00000006
-#define AR_KEYTABLE_TYPE_CLR    0x00000007
-#define AR_KEYTABLE_ANT         0x00000008
-#define AR_KEYTABLE_VALID       0x00008000
-#define AR_KEYTABLE_KEY0(_n)    (AR_KEYTABLE(_n) + 0)
-#define AR_KEYTABLE_KEY1(_n)    (AR_KEYTABLE(_n) + 4)
-#define AR_KEYTABLE_KEY2(_n)    (AR_KEYTABLE(_n) + 8)
-#define AR_KEYTABLE_KEY3(_n)    (AR_KEYTABLE(_n) + 12)
-#define AR_KEYTABLE_KEY4(_n)    (AR_KEYTABLE(_n) + 16)
-#define AR_KEYTABLE_TYPE(_n)    (AR_KEYTABLE(_n) + 20)
-#define AR_KEYTABLE_MAC0(_n)    (AR_KEYTABLE(_n) + 24)
-#define AR_KEYTABLE_MAC1(_n)    (AR_KEYTABLE(_n) + 28)
-
 #define AR9271_CORE_CLOCK	117   /* clock to 117Mhz */
 #define AR9271_TARGET_BAUD_RATE	19200 /* 115200 */
 
