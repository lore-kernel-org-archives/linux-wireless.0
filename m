Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:38401 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921Ab2KVUMI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 15:12:08 -0500
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v9 2/2] wireless: integrate wil6210 driver into build
Date: Thu, 22 Nov 2012 15:25:34 +0200
Message-ID: <1353590734-28704-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20121122_211216_928333_7D9D4A7B)
In-Reply-To: <1353590734-28704-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1353590734-28704-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
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
index 1a67a4f..2c02b4e 100644
--- a/drivers/net/wireless/ath/Kconfig
+++ b/drivers/net/wireless/ath/Kconfig
@@ -30,5 +30,6 @@ source "drivers/net/wireless/ath/ath9k/Kconfig"
 source "drivers/net/wireless/ath/carl9170/Kconfig"
 source "drivers/net/wireless/ath/ath6kl/Kconfig"
 source "drivers/net/wireless/ath/ar5523/Kconfig"
+source "drivers/net/wireless/ath/wil6210/Kconfig"
 
 endif
diff --git a/drivers/net/wireless/ath/Makefile b/drivers/net/wireless/ath/Makefile
index 1e18621..97b964d 100644
--- a/drivers/net/wireless/ath/Makefile
+++ b/drivers/net/wireless/ath/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_ATH9K_HW)		+= ath9k/
 obj-$(CONFIG_CARL9170)		+= carl9170/
 obj-$(CONFIG_ATH6KL)		+= ath6kl/
 obj-$(CONFIG_AR5523)		+= ar5523/
+obj-$(CONFIG_WIL6210)		+= wil6210/
 
 obj-$(CONFIG_ATH_COMMON)	+= ath.o
 
-- 
1.7.10.4

