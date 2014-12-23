Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21144 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097AbaLWHsc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 02:48:32 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Hamad Kadmany <QCA_hkadmany@QCA.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 11/22] wil6210: Increase number of associated stations
Date: Tue, 23 Dec 2014 09:47:13 +0200
Message-Id: <1419320844-23989-12-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141223_091348_472602_AF83EC74)
In-Reply-To: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change default to support maximum number of associated
stations to an AP

Signed-off-by: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 70b055c..245215a 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -23,7 +23,7 @@
 #include "wmi.h"
 #include "trace.h"
 
-static uint max_assoc_sta = 1;
+static uint max_assoc_sta = WIL6210_MAX_CID;
 module_param(max_assoc_sta, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(max_assoc_sta, " Max number of stations associated to the AP");
 
-- 
2.1.0

