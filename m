Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:43665 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178AbaCKKX7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 06:23:59 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH trivial 12/16] ath6kl: Spelling s/determnine/determine/
Date: Tue, 11 Mar 2014 11:23:46 +0100
Message-Id: <1394533430-4746-12-git-send-email-geert@linux-m68k.org> (sfid-20140311_113318_756532_4935A419)
In-Reply-To: <1394533430-4746-1-git-send-email-geert@linux-m68k.org>
References: <1394533430-4746-1-git-send-email-geert@linux-m68k.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/ath/ath6kl/wmi.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index b5f226503baf..5c702ae4d9f8 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1068,7 +1068,7 @@ struct wmi_power_mode_cmd {
 } __packed;
 
 /*
- * Policy to determnine whether power save failure event should be sent to
+ * Policy to determine whether power save failure event should be sent to
  * host during scanning
  */
 enum power_save_fail_event_policy {
-- 
1.7.9.5

