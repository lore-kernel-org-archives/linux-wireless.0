Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53097 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab1DRNgO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 09:36:14 -0400
Received: by mail-fx0-f46.google.com with SMTP id 17so2833789fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 06:36:13 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 18/23] rt2x00: Enable support for RT53xx PCI devices by default.
Date: Mon, 18 Apr 2011 15:33:20 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201104181526.01722.IvDoorn@gmail.com> <201104181532.34476.IvDoorn@gmail.com> <201104181533.00721.IvDoorn@gmail.com>
In-Reply-To: <201104181533.00721.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104181533.21229.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

Code seems to be feature-complete, so no reason to not enable
these devices by default.

Also, remove the sentence about the support for these devices being
non-functional.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/Kconfig |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index e7e361e..d7e27b3 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -96,15 +96,12 @@ config RT2800PCI_RT35XX
 config RT2800PCI_RT53XX
        bool "rt2800-pci - Include support for rt53xx devices (EXPERIMENTAL)"
        depends on EXPERIMENTAL
-       default n
+       default y
        ---help---
          This adds support for rt53xx wireless chipset family to the
          rt2800pci driver.
          Supported chips: RT5390
 
-         Support for these devices is non-functional at the moment and is
-         intended for testers and developers.
-
 endif
 
 config RT2500USB
-- 
1.7.2.3

