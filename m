Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33742 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab2BHGHY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 01:07:24 -0500
Received: by daed14 with SMTP id d14so205953dae.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2012 22:07:24 -0800 (PST)
From: John Li <john.li.mediatek@gmail.com>
To: users@rt2x00.serialmonkey.com
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	John Li <chen-yang.li@mediatek.com>
Subject: [PATCH] rt2x00:Fix typo
Date: Wed,  8 Feb 2012 14:06:48 +0800
Message-Id: <1328681208-5734-1-git-send-email-john.li.mediatek@gmail.com> (sfid-20120208_070726_571001_59FF0435)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: John Li <chen-yang.li@mediatek.com>

---
 drivers/net/wireless/rt2x00/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index a0a7854..299c387 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -163,7 +163,7 @@ config RT2800USB_RT53XX
        depends on EXPERIMENTAL
        ---help---
          This adds support for rt53xx wireless chipset family to the
-         rt2800pci driver.
+         rt2800usb driver.
          Supported chips: RT5370
 
 config RT2800USB_UNKNOWN
-- 
1.7.6.5

