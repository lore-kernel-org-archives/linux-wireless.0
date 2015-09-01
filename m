Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:28681 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402AbbIAOzI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2015 10:55:08 -0400
From: Robert Dolca <robert.dolca@intel.com>
To: linux-nfc@lists.01.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	Christophe Ricard <christophe.ricard@gmail.com>,
	Robert Dolca <robert.dolca@intel.com>
Subject: [PATCH v2 1/9] nfc: nci: Export nci data send API
Date: Tue,  1 Sep 2015 17:54:20 +0300
Message-Id: <1441119268-30654-2-git-send-email-robert.dolca@intel.com> (sfid-20150901_170007_790203_C3754D09)
In-Reply-To: <1441119268-30654-1-git-send-email-robert.dolca@intel.com>
References: <1441119268-30654-1-git-send-email-robert.dolca@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For the firmware update the driver may use nci_send_data.

Signed-off-by: Robert Dolca <robert.dolca@intel.com>
---
 net/nfc/nci/data.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/nfc/nci/data.c b/net/nfc/nci/data.c
index 566466d..83acd18 100644
--- a/net/nfc/nci/data.c
+++ b/net/nfc/nci/data.c
@@ -203,6 +203,7 @@ free_exit:
 exit:
 	return rc;
 }
+EXPORT_SYMBOL(nci_send_data);
 
 /* ----------------- NCI RX Data ----------------- */
 
-- 
1.9.1

