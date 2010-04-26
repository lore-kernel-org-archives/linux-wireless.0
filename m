Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:21230 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab0DZLuo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 07:50:44 -0400
Received: by fg-out-1718.google.com with SMTP id d23so2498742fga.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Apr 2010 04:50:43 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: rt2800lib: Remove redundant check for RT2872
Date: Mon, 26 Apr 2010 13:50:27 +0200
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201004261350.27212.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove redundant check for RT2872.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 1358d9a..b30d59c 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2018,7 +2018,6 @@ int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 		EEPROM(rt2x00dev, "Antenna: 0x%04x\n", word);
 	} else if (rt2x00_rt(rt2x00dev, RT2860) ||
 		   rt2x00_rt(rt2x00dev, RT2870) ||
-		   rt2x00_rt(rt2x00dev, RT2872) ||
 		   rt2x00_rt(rt2x00dev, RT2872)) {
 		/*
 		 * There is a max of 2 RX streams for RT28x0 series
-- 
1.6.4.2

