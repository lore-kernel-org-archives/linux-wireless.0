Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50881 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S981112AbdDYSkr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 14:40:47 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        devicetree@vger.kernel.org, Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH v4 5/9] NFC: trf7970a: Remove useless comment
Date: Tue, 25 Apr 2017 11:40:32 -0700
Message-Id: <20170425184036.1212-6-mgreer@animalcreek.com> (sfid-20170425_204105_819694_C4ADED49)
In-Reply-To: <20170425184036.1212-1-mgreer@animalcreek.com>
References: <20170425184036.1212-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The last entry in the trf7970a_of_match[] table must be an empty
entry to demarcate the end of the table.  Currently, there is a
comment indicating this but it is obvious so remove the comment.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 drivers/nfc/trf7970a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index 4655680b0e7b..b9a90843ea35 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -2273,7 +2273,7 @@ static const struct dev_pm_ops trf7970a_pm_ops = {
 
 static const struct of_device_id trf7970a_of_match[] = {
 	{ .compatible = "ti,trf7970a", },
-	{ /* sentinel */ },
+	{},
 };
 MODULE_DEVICE_TABLE(of, trf7970a_of_match);
 
-- 
2.12.0
