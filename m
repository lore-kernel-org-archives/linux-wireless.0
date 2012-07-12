Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9249 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161288Ab2GLRRw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 13:17:52 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Dave Jones <davej@redhat.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 2/2] NFC: NCI module license 'unspecified' taints kernel
Date: Thu, 12 Jul 2012 19:17:34 +0200
Message-Id: <1342113454-23110-3-git-send-email-sameo@linux.intel.com> (sfid-20120712_191755_130740_3CAAC794)
In-Reply-To: <1342113454-23110-1-git-send-email-sameo@linux.intel.com>
References: <1342113454-23110-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dave Jones <davej@redhat.com>

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/nci/core.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index d560e6f..f18f207 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -27,6 +27,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": %s: " fmt, __func__
 
+#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/workqueue.h>
 #include <linux/completion.h>
@@ -878,3 +879,5 @@ static void nci_cmd_work(struct work_struct *work)
 			  jiffies + msecs_to_jiffies(NCI_CMD_TIMEOUT));
 	}
 }
+
+MODULE_LICENSE("GPL");
-- 
1.7.10

