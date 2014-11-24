Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:45625 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbaKXOe6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:34:58 -0500
Received: by mail-wg0-f53.google.com with SMTP id l18so12519432wgh.12
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:34:57 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/75] iwlwfifi: fix WANT_DEV_COREDUMP selection in Kconfig
Date: Mon, 24 Nov 2014 16:33:37 +0200
Message-Id: <1416839691-28533-1-git-send-email-egrumbach@gmail.com> (sfid-20141124_153501_871519_3ADC47DE)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Fix my mistake while sending Johannes's

commit aadede6e9f4c8ee46808b2f697b714ee50810e23
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Thu Oct 9 17:01:36 2014 +0200

    iwlwifi: mvm: port to devcoredump framework

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 139de90..ab019b4 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -59,7 +59,7 @@ config IWLDVM
 
 config IWLMVM
 	tristate "Intel Wireless WiFi MVM Firmware support"
-	select BACKPORT_WANT_DEV_COREDUMP
+	select WANT_DEV_COREDUMP
 	help
 	  This is the driver that supports the MVM firmware which is
 	  currently only available for 7260 and 3160 devices.
-- 
1.9.1

