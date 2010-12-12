Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f170.google.com ([209.85.214.170]:65431 "EHLO
	mail-iw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab0LLK6a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Dec 2010 05:58:30 -0500
Received: by iwn6 with SMTP id 6so7673121iwn.1
        for <linux-wireless@vger.kernel.org>; Sun, 12 Dec 2010 02:58:30 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19716.42366.724562.760266@gargle.gargle.HOWL>
Date: Sun, 12 Dec 2010 16:05:42 +0530
To: Seb <louis_sr@yahoo.com>
Cc: linux-wireless@vger.kernel.org
Subject: Support for Ubiquiti WiFi Station Ext (USB) with Atheros AR9271 Chipset
In-Reply-To: <53064.98461.qm@web36301.mail.mud.yahoo.com>
References: <53064.98461.qm@web36301.mail.mud.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Seb wrote:
> Hello
> 
> I tested this product under linux and impossible to make it works.
> Vendor ID = 0cf3
> Product ID = b003

We'll add this to the supported devices list.

> I compiled compat-wireless to make it detected by modifying the ath9k/hif-usb.c
> and when loading, the firmware failed
> 
> usb 1-1: ath9k_htc: Firmware - ar9271.fw download failed
> ath9k_hif_usb: probe of 1-1:1.0 failed with error -22
> usbcore: registered new interface driver ath9k_hif_usb
> 
> # ls -l /lib/firmware-2.6.35.8/ar9271.fw
> -rw-r--r-- 1 root root 51280 Nov 10 05:56 /lib/firmware-2.6.35.8/ar9271.fw

It should work if the correct firmware is loaded.
Which distribution are you using ?
And is /lib/firmware-2.6.35.8/ the correct firmware location ?

Sujith
