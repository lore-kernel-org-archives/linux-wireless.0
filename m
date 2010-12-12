Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web36301.mail.mud.yahoo.com ([209.191.91.178]:23038 "HELO
	web36301.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750838Ab0LLJlz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Dec 2010 04:41:55 -0500
Message-ID: <53064.98461.qm@web36301.mail.mud.yahoo.com>
Date: Sun, 12 Dec 2010 01:41:53 -0800 (PST)
From: Seb <louis_sr@yahoo.com>
Subject: Support for Ubiquiti WiFi Station Ext (USB) with Atheros AR9271 Chipset
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

I tested this product under linux and impossible to make it works.
Vendor ID = 0cf3
Product ID = b003
Bus 001 Device 002: ID 0cf3:b003 Atheros Communications, Inc. AR9271 802.11n

I compiled compat-wireless to make it detected by modifying the ath9k/hif-usb.c
and when loading, the firmware failed

usb 1-1: ath9k_htc: Firmware - ar9271.fw download failed
ath9k_hif_usb: probe of 1-1:1.0 failed with error -22
usbcore: registered new interface driver ath9k_hif_usb

# ls -l /lib/firmware-2.6.35.8/ar9271.fw
-rw-r--r-- 1 root root 51280 Nov 10 05:56 /lib/firmware-2.6.35.8/ar9271.fw

Is there a way to help making this product recognized under linux ?


      
