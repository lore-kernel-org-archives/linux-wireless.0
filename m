Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34101 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544AbaDMTVR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:21:17 -0400
Received: by mail-wg0-f42.google.com with SMTP id y10so7269889wgg.13
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:21:16 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 45/47] iwlwifi: mvm: replace leading spaces by tabs
Date: Sun, 13 Apr 2014 22:20:00 +0300
Message-Id: <1397416802-32403-45-git-send-email-egrumbach@gmail.com> (sfid-20140413_213517_741365_B1379B27)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Somehow I added spaces instead of tabs to a few lines in
debugfs.c.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index c152188..f462c9b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -1106,9 +1106,9 @@ MVM_DEBUGFS_READ_WRITE_FILE_OPS(scan_ant_rxchain, 8);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(d0i3_refs, 8);
 
 static const struct file_operations iwl_dbgfs_fw_error_dump_ops = {
-        .open = iwl_dbgfs_fw_error_dump_open,
-        .read = iwl_dbgfs_fw_error_dump_read,
-        .release = iwl_dbgfs_fw_error_dump_release,
+	.open = iwl_dbgfs_fw_error_dump_open,
+	.read = iwl_dbgfs_fw_error_dump_read,
+	.release = iwl_dbgfs_fw_error_dump_release,
 };
 
 #ifdef CONFIG_IWLWIFI_BCAST_FILTERING
-- 
1.8.3.2

