Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:44749 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbbCCGdb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 01:33:31 -0500
Received: by wesk11 with SMTP id k11so37740108wes.11
        for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2015 22:33:30 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH next] bcma: add missing includes
Date: Tue,  3 Mar 2015 07:32:57 +0100
Message-Id: <1425364377-12771-1-git-send-email-zajec5@gmail.com> (sfid-20150303_073348_141987_FFBE46EB)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/driver_pci_host.c | 1 +
 drivers/bcma/driver_pcie2.c    | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
index c8a6b74..c42cec7 100644
--- a/drivers/bcma/driver_pci_host.c
+++ b/drivers/bcma/driver_pci_host.c
@@ -11,6 +11,7 @@
 
 #include "bcma_private.h"
 #include <linux/pci.h>
+#include <linux/slab.h>
 #include <linux/export.h>
 #include <linux/bcma/bcma.h>
 #include <asm/paccess.h>
diff --git a/drivers/bcma/driver_pcie2.c b/drivers/bcma/driver_pcie2.c
index 4568bc7..b1a6e32 100644
--- a/drivers/bcma/driver_pcie2.c
+++ b/drivers/bcma/driver_pcie2.c
@@ -10,6 +10,7 @@
 
 #include "bcma_private.h"
 #include <linux/bcma/bcma.h>
+#include <linux/pci.h>
 
 /**************************************************
  * R/W ops.
-- 
1.8.4.5

