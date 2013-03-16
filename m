Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:37022 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932507Ab3CPSUB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 14:20:01 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 15/25] rt2800: 5592: enable rf init
Date: Sat, 16 Mar 2013 19:19:43 +0100
Message-Id: <1363457993-15541-16-git-send-email-stf_xl@wp.pl> (sfid-20130316_192014_869713_C6E3701F)
In-Reply-To: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
References: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 189c880..1650cf4 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4691,6 +4691,7 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	    !rt2x00_rt(rt2x00dev, RT5390) &&
 	    !rt2x00_rt(rt2x00dev, RT5392) &&
 	    !rt2x00_rt(rt2x00dev, RT5392) &&
+	    !rt2x00_rt(rt2x00dev, RT5592) &&
 	    !rt2800_is_305x_soc(rt2x00dev))
 		return 0;
 
-- 
1.7.4.4

