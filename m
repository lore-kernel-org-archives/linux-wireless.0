Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31091 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547AbbCLNF6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:05:58 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 27/49] iwlwifi: pcie: include more registers in the prph dump
Date: Thu, 12 Mar 2015 15:04:12 +0200
Message-Id: <1426165474-25586-27-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_143419_443407_53D1DFC5)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds BT Coex data to the prph register list.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 4c16333..421ef6b 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1961,24 +1961,25 @@ static const struct {
 	{ .start = 0x00a01c7c, .end = 0x00a01c7c },
 	{ .start = 0x00a01c28, .end = 0x00a01c54 },
 	{ .start = 0x00a01c5c, .end = 0x00a01c5c },
-	{ .start = 0x00a01c84, .end = 0x00a01c84 },
+	{ .start = 0x00a01c60, .end = 0x00a01cdc },
 	{ .start = 0x00a01ce0, .end = 0x00a01d0c },
 	{ .start = 0x00a01d18, .end = 0x00a01d20 },
 	{ .start = 0x00a01d2c, .end = 0x00a01d30 },
 	{ .start = 0x00a01d40, .end = 0x00a01d5c },
 	{ .start = 0x00a01d80, .end = 0x00a01d80 },
-	{ .start = 0x00a01d98, .end = 0x00a01d98 },
+	{ .start = 0x00a01d98, .end = 0x00a01d9c },
+	{ .start = 0x00a01da8, .end = 0x00a01da8 },
+	{ .start = 0x00a01db8, .end = 0x00a01df4 },
 	{ .start = 0x00a01dc0, .end = 0x00a01dfc },
 	{ .start = 0x00a01e00, .end = 0x00a01e2c },
 	{ .start = 0x00a01e40, .end = 0x00a01e60 },
+	{ .start = 0x00a01e68, .end = 0x00a01e6c },
+	{ .start = 0x00a01e74, .end = 0x00a01e74 },
 	{ .start = 0x00a01e84, .end = 0x00a01e90 },
 	{ .start = 0x00a01e9c, .end = 0x00a01ec4 },
-	{ .start = 0x00a01ed0, .end = 0x00a01ed0 },
-	{ .start = 0x00a01f00, .end = 0x00a01f14 },
-	{ .start = 0x00a01f44, .end = 0x00a01f58 },
-	{ .start = 0x00a01f80, .end = 0x00a01fa8 },
-	{ .start = 0x00a01fb0, .end = 0x00a01fbc },
-	{ .start = 0x00a01ff8, .end = 0x00a01ffc },
+	{ .start = 0x00a01ed0, .end = 0x00a01ee0 },
+	{ .start = 0x00a01f00, .end = 0x00a01f1c },
+	{ .start = 0x00a01f44, .end = 0x00a01ffc },
 	{ .start = 0x00a02000, .end = 0x00a02048 },
 	{ .start = 0x00a02068, .end = 0x00a020f0 },
 	{ .start = 0x00a02100, .end = 0x00a02118 },
-- 
1.9.1

