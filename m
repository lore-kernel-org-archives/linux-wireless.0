Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:56838 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab0ABRVE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2010 12:21:04 -0500
Received: by fg-out-1718.google.com with SMTP id 19so5898218fgg.1
        for <linux-wireless@vger.kernel.org>; Sat, 02 Jan 2010 09:21:02 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Add new SSB's core id for BCM4328
References: <op.u5wyi5dd9lhzdc@linux-g0th.site>
 <4B3F78ED.4090101@lwfinger.net>
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Sat, 02 Jan 2010 18:22:17 +0100
Message-ID: <op.u5w07fj09lhzdc@linux-g0th.site>
In-Reply-To: <4B3F78ED.4090101@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

White-spaces fixed.

 From 9b3ea4f29b038f732aba737323e2f89b275ce1ab Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Date: Sat, 2 Jan 2010 16:58:16 +0100
Subject: [PATCH] b43: Add new SSB's core id for BCM4328
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Following line shows my BCM4328 detected on SSB. We didn't include 0x0C rev.
ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0C, vendor 0x4243)

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/main.c |    1 +
  1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 098dda1..3aa45b8 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -110,6 +110,7 @@ static const struct ssb_device_id b43_ssb_tbl[] = {
  	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 9),
  	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 10),
  	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 11),
+	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 12),
  	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 13),
  	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 15),
  	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 16),
-- 
1.6.4.2
