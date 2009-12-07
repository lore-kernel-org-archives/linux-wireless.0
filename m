Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:65290 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934893AbZLGKFt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2009 05:05:49 -0500
Received: by ewy19 with SMTP id 19so212817ewy.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Dec 2009 02:05:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091204192315.GA5786@tuxdriver.com>
References: <bf87febf0912030507u1c36f6a9h7cac0efabf3d016@mail.gmail.com>
	 <20091204192315.GA5786@tuxdriver.com>
Date: Mon, 7 Dec 2009 12:05:54 +0200
Message-ID: <bf87febf0912070205k40a7286dpbb48cfcc494203d2@mail.gmail.com>
Subject: Re: [PATCH] ath5k: add support for Dell Vostro A860 LED
From: Shahar Or <mightyiampresence@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	me@bobcopeland.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adds support for the WiFi activity LED on the Dell Vostro A860 laptop.

Signed-off-by: Shahar Or <shahar@shahar-or.co.il>
---
I hope this one is perfect.
--- drivers/net/wireless/ath/ath5k/led.c.orig	2009-12-03
14:57:20.000000000 +0200
+++ drivers/net/wireless/ath/ath5k/led.c	2009-12-03 14:25:30.000000000 +0200
@@ -71,6 +71,8 @@
 	{ ATH_SDEVICE(PCI_VENDOR_ID_IBM, 0x058a), ATH_LED(1, 0) },
 	/* IBM-specific AR5212 (all others) */
 	{ PCI_VDEVICE(ATHEROS, PCI_DEVICE_ID_ATHEROS_AR5212_IBM), ATH_LED(0, 0) },
+	/* Dell Vostro A860 (shahar@shahar-or.co.il) */
+	{ ATH_SDEVICE(PCI_VENDOR_ID_QMI, 0x0112), ATH_LED(3, 0) },
 	{ }
 };
