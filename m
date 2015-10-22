Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:33648 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452AbbJVJMN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2015 05:12:13 -0400
From: Robert Dolca <robert.dolca@intel.com>
To: linux-nfc@lists.01.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Robert Dolca <robert.dolca@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	Christophe Ricard <christophe.ricard@gmail.com>,
	Robert Dolca <robert.dolca@intel.com>
Subject: [PATCH v4 01/10] nfc: nci: Export nci data send API
Date: Thu, 22 Oct 2015 12:11:33 +0300
Message-Id: <1445505102-16639-2-git-send-email-robert.dolca@intel.com> (sfid-20151022_113654_463078_FC6798C0)
In-Reply-To: <1445505102-16639-1-git-send-email-robert.dolca@intel.com>
References: <1445505102-16639-1-git-send-email-robert.dolca@intel.com>
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

