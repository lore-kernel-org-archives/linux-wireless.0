Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55090 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327Ab1KRTAq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 14:00:46 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	"Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] compat-wireless: change CONFIG_IWLAGN -> CONFIG_IWLWIFI
Date: Fri, 18 Nov 2011 13:46:18 -0500
Message-Id: <1321641978-2787-1-git-send-email-linville@tuxdriver.com> (sfid-20111118_200055_853449_7FAC7950)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This Kconfig option changed in the 2.6.32 timeframe.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 config.mk |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/config.mk b/config.mk
index a71de4e..87bd16a 100644
--- a/config.mk
+++ b/config.mk
@@ -246,7 +246,7 @@ ifdef CONFIG_PCI
 CONFIG_ATH5K_PCI=y
 CONFIG_ATH9K_PCI=y
 
-CONFIG_IWLAGN=m
+CONFIG_IWLWIFI=m
 # CONFIG_IWLWIFI_DEBUG=y
 # CONFIG_IWLWIFI_DEBUGFS=y
 # CONFIG_IWLWIFI_DEVICE_TRACING=y
-- 
1.7.4.4

