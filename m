Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39524 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758511Ab2DXXv2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 19:51:28 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/11] iwlwifi: add reduced tx power threshold define
Date: Tue, 24 Apr 2012 16:45:57 -0700
Message-Id: <1335311164-10252-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120425_015205_415972_0A9EFB10)
In-Reply-To: <1335311164-10252-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335311164-10252-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index c212e53..5e02b4f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3634,6 +3634,9 @@ enum iwl_bt_coex_profile_traffic_load {
 		(0x3<<BT_UART_MSG_2_FRAME7RESERVED_POS)
 
 
+#define BT_ENABLE_REDUCED_TXPOWER_THRESHOLD	(-62)
+#define BT_DISABLE_REDUCED_TXPOWER_THRESHOLD	(-65)
+
 struct iwl_bt_uart_msg {
 	u8 header;
 	u8 frame1;
-- 
1.7.0.4

