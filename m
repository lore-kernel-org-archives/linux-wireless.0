Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail10.dslextreme.com ([66.51.199.98]:51938 "HELO
	mail10.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751182Ab0CFQkK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Mar 2010 11:40:10 -0500
Message-ID: <4B928564.4050709@gmail.com>
Date: Sat, 06 Mar 2010 08:40:04 -0800
From: Gus Wirth <gwirth79@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ar9170 compat-wireless build failure
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While trying to build the compat-wireless drivers on a Fedora 11 system
with a 2.6.30.10 kernel, I get the following error message during compile:

/home/gus/src/compat-wireless/compat-wireless-2010-03-05/drivers/net/wireless/ath/ar9170/usb.c:
In function ‘ar9170_usb_firmware_failed’:
/home/gus/src/compat-wireless/compat-wireless-2010-03-05/drivers/net/wireless/ath/ar9170/usb.c:730:
error: implicit declaration of function ‘device_lock’
/home/gus/src/compat-wireless/compat-wireless-2010-03-05/drivers/net/wireless/ath/ar9170/usb.c:733:
error: implicit declaration of function ‘device_unlock’

I've grep'd through the sources and can't find any device_lock function,
so this appears to be missing from either compat-wireless or my kernel.

Gus
