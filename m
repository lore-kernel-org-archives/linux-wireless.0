Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54032 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab1JJPQ0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 11:16:26 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/34] iwlagn: add REPLY_ECHO host command
Date: Mon, 10 Oct 2011 07:26:47 -0700
Message-Id: <1318256839-31837-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111010_171743_752392_AF278F1F)
In-Reply-To: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add "echo" host command for testing and drebugging to make sure uCode still
responding

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 64593aa..9a5d993 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -89,6 +89,7 @@ struct iwl_priv;
 enum {
 	REPLY_ALIVE = 0x1,
 	REPLY_ERROR = 0x2,
+	REPLY_ECHO = 0x3,		/* test command */
 
 	/* RXON and QOS commands */
 	REPLY_RXON = 0x10,
-- 
1.7.0.4

