Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:38229 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab2JUNJS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Oct 2012 09:09:18 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v1 2/2] wireless: integrate wil6210 driver into build structure
Date: Sun, 21 Oct 2012 15:02:51 +0200
Message-ID: <1350824571-22554-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20121021_150922_722089_28FD7A7E)
In-Reply-To: <1350824571-22554-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1350824571-22554-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/Kconfig  |    1 +
 drivers/net/wireless/ath/Makefile |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/Kconfig b/drivers/net/wireless/ath/Kconfig
index 0960224..282999f 100644
--- a/drivers/net/wireless/ath/Kconfig
+++ b/drivers/net/wireless/ath/Kconfig
@@ -28,3 +28,4 @@ source "drivers/net/wireless/ath/carl9170/Kconfig"
 source "drivers/net/wireless/ath/ath6kl/Kconfig"
 
 endif
+source "drivers/net/wireless/ath/wil6210/Kconfig"
diff --git a/drivers/net/wireless/ath/Makefile b/drivers/net/wireless/ath/Makefile
index d716b74..b1af57b 100644
--- a/drivers/net/wireless/ath/Makefile
+++ b/drivers/net/wireless/ath/Makefile
@@ -2,6 +2,7 @@ obj-$(CONFIG_ATH5K)		+= ath5k/
 obj-$(CONFIG_ATH9K_HW)		+= ath9k/
 obj-$(CONFIG_CARL9170)		+= carl9170/
 obj-$(CONFIG_ATH6KL)		+= ath6kl/
+obj-$(CONFIG_WIL6210)		+= wil6210/
 
 obj-$(CONFIG_ATH_COMMON)	+= ath.o
 
-- 
1.7.10.4

