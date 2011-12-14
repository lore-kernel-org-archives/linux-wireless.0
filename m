Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37333 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464Ab1LNV4n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 16:56:43 -0500
Received: by ghbz12 with SMTP id z12so1016355ghb.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Dec 2011 13:56:42 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	wtsao@qca.qualcomm.com, rmanohar@qca.qualcomm.com,
	mohammed@qca.qualcomm.com, senthilb@qca.qualcomm.com
Subject: [PATCH] ath: document ATH_DBG_MCI
Date: Wed, 14 Dec 2011 13:56:36 -0800
Message-Id: <1323899796-21170-1-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111214_225645_392987_D4C4EE00)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A debug level was added to the ath module for printing
MCI messages but no documentation was provided. Clarify that
MCI is the Message Coexistence Interface, a private protocol
used exclusively for WLAN-BT coexistence starting from
AR9462.

Cc: wtsao@qca.qualcomm.com
Cc: rmanohar@qca.qualcomm.com
Cc: mohammed@qca.qualcomm.com
Cc: senthilb@qca.qualcomm.com
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 3e4dd2d..0b93bab 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -215,6 +215,9 @@ do {								\
  * @ATH_DBG_HWTIMER: hardware timer handling
  * @ATH_DBG_BTCOEX: bluetooth coexistance
  * @ATH_DBG_BSTUCK: stuck beacons
+ * @ATH_DBG_MCI: Message Coexistence Interface, a private protocol
+ *	used exclusively for WLAN-BT coexistence starting from
+ *	AR9462.
  * @ATH_DBG_ANY: enable all debugging
  *
  * The debug level is used to control the amount and type of debugging output
-- 
1.7.4.15.g7811d

