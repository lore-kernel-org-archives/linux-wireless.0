Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755006Ab1FHN2k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 09:28:40 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/6] iwlegacy: remove unused power commands defines
Date: Wed,  8 Jun 2011 15:28:24 +0200
Message-Id: <1307539709-11320-1-git-send-email-sgruszka@redhat.com> (sfid-20110608_152843_215067_F971526D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-commands.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-commands.h b/drivers/net/wireless/iwlegacy/iwl-commands.h
index 17a1d50..ee21210 100644
--- a/drivers/net/wireless/iwlegacy/iwl-commands.h
+++ b/drivers/net/wireless/iwlegacy/iwl-commands.h
@@ -2297,14 +2297,7 @@ struct iwl_spectrum_notification {
 #define IWL_POWER_VEC_SIZE 5
 
 #define IWL_POWER_DRIVER_ALLOW_SLEEP_MSK	cpu_to_le16(BIT(0))
-#define IWL_POWER_POWER_SAVE_ENA_MSK		cpu_to_le16(BIT(0))
-#define IWL_POWER_POWER_MANAGEMENT_ENA_MSK	cpu_to_le16(BIT(1))
-#define IWL_POWER_SLEEP_OVER_DTIM_MSK		cpu_to_le16(BIT(2))
 #define IWL_POWER_PCI_PM_MSK			cpu_to_le16(BIT(3))
-#define IWL_POWER_FAST_PD			cpu_to_le16(BIT(4))
-#define IWL_POWER_BEACON_FILTERING		cpu_to_le16(BIT(5))
-#define IWL_POWER_SHADOW_REG_ENA		cpu_to_le16(BIT(6))
-#define IWL_POWER_CT_KILL_SET			cpu_to_le16(BIT(7))
 
 struct iwl3945_powertable_cmd {
 	__le16 flags;
-- 
1.7.1

