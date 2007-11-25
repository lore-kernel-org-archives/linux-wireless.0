Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:37174 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbXKYO6M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2007 09:58:12 -0500
Received: by py-out-1112.google.com with SMTP id u77so761836pyb
        for <linux-wireless@vger.kernel.org>; Sun, 25 Nov 2007 06:58:11 -0800 (PST)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] iwlwifi: remove redundant declaration of 'iwl3945_priv' and 'iwl4965_priv' structs
Date: Sun, 25 Nov 2007 15:58:07 +0100
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200711251558.07511.mboton@gmail.com> (sfid-20071125_145818_286151_C773FB88)
From: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes a redundant declaration of 'iwl3945_priv' and 'iwl49=
65_priv' structs.

Signed-off-by: Miguel Boton <mboton@gmail.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wire=
less/iwlwifi/iwl-3945.h
index 49556e6..70f3fc0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -31,8 +31,6 @@
 #include <linux/kernel.h>
 #include <net/ieee80211_radiotap.h>
=20
-struct iwl3945_priv;
-
 /* Hardware specific file defines the PCI IDs table for that hardware =
module */
 extern struct pci_device_id iwl3945_hw_card_ids[];
=20
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wire=
less/iwlwifi/iwl-4965.h
index 5944b4b..949630c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -30,8 +30,6 @@
 #include <linux/kernel.h>
 #include <net/ieee80211_radiotap.h>
=20
-struct iwl4965_priv;
-
 /* Hardware specific file defines the PCI IDs table for that hardware =
module */
 extern struct pci_device_id iwl4965_hw_card_ids[];
=20

--=20
	Miguel Bot=C3=B3n
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
