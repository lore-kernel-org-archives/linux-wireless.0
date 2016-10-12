Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:43008 "EHLO
        lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755564AbcJLS6i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 14:58:38 -0400
Received: from localhost.localdomain (proxy [81.2.110.250])
        by lxorguk.ukuu.org.uk (8.15.2/8.14.1) with ESMTP id u9CIvbkt023444
        for <linux-wireless@vger.kernel.org>; Wed, 12 Oct 2016 19:57:43 +0100
Subject: [PATCH] ath6k1: add Dell OEM SDIO I/O for the Venue 8 Pro
From: Alan <alan@linux.intel.com>
To: linux-wireless@vger.kernel.org
Date: Wed, 12 Oct 2016 19:08:40 +0100
Message-ID: <147629570687.26062.4786752681864367162.stgit@localhost.localdomain> (sfid-20161012_205841_577924_568593B0)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Adam Williamson <adamw@happyassassin.net>

SDIO ID 0271:0418

Signed-off-by: Alan Cox <alan@linux.intel.com>
Bugzilla-ID: https://bugzilla.kernel.org/show_bug.cgi?id=67921

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index eab0ab9..76eb336 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -1401,6 +1401,7 @@ static const struct sdio_device_id ath6kl_sdio_devices[] = {
 	{SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6004_BASE | 0x0))},
 	{SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6004_BASE | 0x1))},
 	{SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6004_BASE | 0x2))},
+	{SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6004_BASE | 0x18))},
 	{},
 };
 
