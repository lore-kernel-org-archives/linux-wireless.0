Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57155 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1429420AbdDYSko (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 14:40:44 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        devicetree@vger.kernel.org, Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH v4 1/9] MAINTAINERS: NFC: trf7970a: Add Mark Greer as maintainer
Date: Tue, 25 Apr 2017 11:40:28 -0700
Message-Id: <20170425184036.1212-2-mgreer@animalcreek.com> (sfid-20170425_204101_708439_D3ADF83F)
In-Reply-To: <20170425184036.1212-1-mgreer@animalcreek.com>
References: <20170425184036.1212-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add Mark Greer as the maintainer of the trf7970a NFC driver.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a8eaa0a8e522..d7441b69f101 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11118,6 +11118,14 @@ F:	kernel/time/alarmtimer.c
 F:	kernel/time/ntp.c
 F:	tools/testing/selftests/timers/
 
+TI TRF7970A NFC DRIVER
+M:	Mark Greer <mgreer@animalcreek.com>
+L:	linux-wireless@vger.kernel.org
+L:	linux-nfc@lists.01.org (moderated for non-subscribers)
+S:	Supported
+F:	drivers/nfc/trf7970a.c
+F:	Documentation/devicetree/bindings/net/nfc/trf7970a.txt
+
 SC1200 WDT DRIVER
 M:	Zwane Mwaikambo <zwanem@gmail.com>
 S:	Maintained
-- 
2.12.0
