Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:25722 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756267Ab0IHWS6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 18:18:58 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 15:18:53 -0700
From: Vipin Mehta <vmehta@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>, <vmehta@atheros.com>,
	<devel@driverdev.osuosl.org>
Subject: [PATCH] staging: ath6kl: Eliminating the symlink to 2.0 header files
Date: Wed, 8 Sep 2010 15:19:48 -0700
Message-ID: <1283984388-5100-1-git-send-email-vmehta@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Moving the AR6002 hw 2.0 specific register definitions files from
the hw.0 directory to a new directory, 'hw' within hw2.0.

Signed-off-by: Vipin Mehta <vmehta@atheros.com>
---
 .../staging/ath6kl/include/common/AR6002/hw2.0/hw  |    1 -
 .../AR6002/{hw.0 => hw2.0/hw}/analog_intf_reg.h    |    0
 .../common/AR6002/{hw.0 => hw2.0/hw}/analog_reg.h  |    0
 .../common/AR6002/{hw.0 => hw2.0/hw}/apb_map.h     |    0
 .../common/AR6002/{hw.0 => hw2.0/hw}/gpio_reg.h    |    0
 .../AR6002/{hw.0 => hw2.0/hw}/mbox_host_reg.h      |    0
 .../common/AR6002/{hw.0 => hw2.0/hw}/mbox_reg.h    |    0
 .../common/AR6002/{hw.0 => hw2.0/hw}/rtc_reg.h     |    0
 .../common/AR6002/{hw.0 => hw2.0/hw}/si_reg.h      |    0
 .../common/AR6002/{hw.0 => hw2.0/hw}/uart_reg.h    |    0
 .../common/AR6002/{hw.0 => hw2.0/hw}/vmc_reg.h     |    0
 11 files changed, 0 insertions(+), 1 deletions(-)
 delete mode 120000 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw
 rename drivers/staging/ath6kl/include/common/AR6002/{hw.0 => hw2.0/hw}/analog_intf_reg.h (100%)
 rename drivers/staging/ath6kl/include/common/AR6002/{hw.0 => hw2.0/hw}/analog_reg.h (100%)
 rename drivers/staging/ath6kl/include/common/AR6002/{hw.0 => hw2.0/hw}/apb_map.h (100%)
 rename drivers/staging/ath6kl/include/common/AR6002/{hw.0 => hw2.0/hw}/gpio_reg.h (100%)
 rename drivers/staging/ath6kl/include/common/AR6002/{hw.0 => hw2.0/hw}/mbox_host_reg.h (100%)
 rename drivers/staging/ath6kl/include/common/AR6002/{hw.0 => hw2.0/hw}/mbox_reg.h (100%)
 rename drivers/staging/ath6kl/include/common/AR6002/{hw.0 => hw2.0/hw}/rtc_reg.h (100%)
 rename drivers/staging/ath6kl/include/common/AR6002/{hw.0 => hw2.0/hw}/si_reg.h (100%)
 rename drivers/staging/ath6kl/include/common/AR6002/{hw.0 => hw2.0/hw}/uart_reg.h (100%)
 rename drivers/staging/ath6kl/include/common/AR6002/{hw.0 => hw2.0/hw}/vmc_reg.h (100%)

diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw
deleted file mode 120000
index 8fae5c6..0000000
--- a/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw
+++ /dev/null
@@ -1 +0,0 @@
-../hw.0
\ No newline at end of file
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw.0/analog_intf_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/analog_intf_reg.h
similarity index 100%
rename from drivers/staging/ath6kl/include/common/AR6002/hw.0/analog_intf_reg.h
rename to drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/analog_intf_reg.h
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw.0/analog_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/analog_reg.h
similarity index 100%
rename from drivers/staging/ath6kl/include/common/AR6002/hw.0/analog_reg.h
rename to drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/analog_reg.h
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw.0/apb_map.h b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/apb_map.h
similarity index 100%
rename from drivers/staging/ath6kl/include/common/AR6002/hw.0/apb_map.h
rename to drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/apb_map.h
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw.0/gpio_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/gpio_reg.h
similarity index 100%
rename from drivers/staging/ath6kl/include/common/AR6002/hw.0/gpio_reg.h
rename to drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/gpio_reg.h
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw.0/mbox_host_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/mbox_host_reg.h
similarity index 100%
rename from drivers/staging/ath6kl/include/common/AR6002/hw.0/mbox_host_reg.h
rename to drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/mbox_host_reg.h
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw.0/mbox_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/mbox_reg.h
similarity index 100%
rename from drivers/staging/ath6kl/include/common/AR6002/hw.0/mbox_reg.h
rename to drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/mbox_reg.h
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw.0/rtc_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/rtc_reg.h
similarity index 100%
rename from drivers/staging/ath6kl/include/common/AR6002/hw.0/rtc_reg.h
rename to drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/rtc_reg.h
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw.0/si_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/si_reg.h
similarity index 100%
rename from drivers/staging/ath6kl/include/common/AR6002/hw.0/si_reg.h
rename to drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/si_reg.h
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw.0/uart_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/uart_reg.h
similarity index 100%
rename from drivers/staging/ath6kl/include/common/AR6002/hw.0/uart_reg.h
rename to drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/uart_reg.h
diff --git a/drivers/staging/ath6kl/include/common/AR6002/hw.0/vmc_reg.h b/drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/vmc_reg.h
similarity index 100%
rename from drivers/staging/ath6kl/include/common/AR6002/hw.0/vmc_reg.h
rename to drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/vmc_reg.h
-- 
1.6.3.3

