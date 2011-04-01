Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54480 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397Ab1DAKI2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 06:08:28 -0400
Received: by wwa36 with SMTP id 36so3885096wwa.1
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 03:08:27 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: =?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/3] ssb: pci: trivial: drop useless pointer
Date: Fri,  1 Apr 2011 12:07:32 +0200
Message-Id: <1301652454-11251-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/driver_pcicore.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/ssb/driver_pcicore.c b/drivers/ssb/driver_pcicore.c
index 0e8d352..e0cf29e 100644
--- a/drivers/ssb/driver_pcicore.c
+++ b/drivers/ssb/driver_pcicore.c
@@ -417,11 +417,9 @@ static void ssb_pcicore_init_clientmode(struct ssb_pcicore *pc)
 void ssb_pcicore_init(struct ssb_pcicore *pc)
 {
 	struct ssb_device *dev = pc->dev;
-	struct ssb_bus *bus;
 
 	if (!dev)
 		return;
-	bus = dev->bus;
 	if (!ssb_device_is_enabled(dev))
 		ssb_device_enable(dev, 0);
 
-- 
1.7.1

