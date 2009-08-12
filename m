Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f191.google.com ([209.85.211.191]:58958 "EHLO
	mail-yw0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbZHLQ7V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 12:59:21 -0400
Received: by ywh29 with SMTP id 29so198933ywh.33
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 09:59:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <15d0b9b20908120920sa42235ft4ce0daed4e4f0130@mail.gmail.com>
References: <15d0b9b20908120920sa42235ft4ce0daed4e4f0130@mail.gmail.com>
Date: Wed, 12 Aug 2009 18:59:21 +0200
Message-ID: <15d0b9b20908120959v758ed06bl40fb25b6374e2805@mail.gmail.com>
Subject: [PATCH 2.6.31-rc5] Staging: rt2870: new USB ID for Belkin N+ F5D8055
From: Daniele Napolitano <dnax88@gmail.com>
To: linux-wireless@vger.kernel.org, gregkh@suse.de,
	akpm@linux-foundation.org, greg@kroah.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New USB ID for Belkin N+ F5D8055 (USB 802.11n adapter).

I've made this patch with drivers/staging branch found here:
http://git.kernel.org/?p=linux/kernel/git/gregkh/staging-2.6.git

Signed-off-by: Daniele Napolitano <dnax88@gmail.com>
--- drivers/staging/rt2870/rt2870.h	2009-08-12 18:06:42.606925649 +0200
+++ drivers/staging/rt2870/rt2870.h~	2009-08-12 18:07:11.698931370 +0200
@@ -102,6 +102,7 @@
 	{USB_DEVICE(0x14B2,0x3C12)}, /* AL */           \
 	{USB_DEVICE(0x050D,0x8053)}, /* Belkin */		\
 	{USB_DEVICE(0x050D,0x815C)}, /* Belkin */		\
+	{USB_DEVICE(0x050D,0x825a)}, /* Belkin */		\
 	{USB_DEVICE(0x14B2,0x3C23)}, /* Airlink */		\
 	{USB_DEVICE(0x14B2,0x3C27)}, /* Airlink */		\
 	{USB_DEVICE(0x07AA,0x002F)}, /* Corega */		\
