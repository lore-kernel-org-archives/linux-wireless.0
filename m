Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:50426 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab3GII7j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 04:59:39 -0400
Received: by mail-ea0-f171.google.com with SMTP id m14so3497271eaj.2
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jul 2013 01:59:38 -0700 (PDT)
From: Dmitry Zganyaiko <dmitry.zganyaiko@gmail.com>
Content-Type: text/plain; charset=us-ascii
Subject: New device for ar5523
Date: Tue, 9 Jul 2013 11:59:36 +0300
Message-Id: <CC807E45-D614-4540-AD3F-160B56795851@gmail.com> (sfid-20130709_105942_691865_3301AFD8)
Cc: linux-wireless@vger.kernel.org
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi! I'm using usb wireless adaptor named
07d1:3a0d D-Link System DWA-120 802.11g Wireless 108G (taken from lsusb)

System is Debian wheezy with 3.8 kernel taken from ubuntu reps. But after launch this adaptor doesn't work: no any new network interfaces is shown in ifconfig.

As far as I understood, such vendor:product (07d1:3a0d) isn't specified in drivers/net/wireless/ath/ar5523/ar5523.c, and therefore the driver doesn't recognise my device. Firmware 'ar5523.bin' is located in /usr/local/lib/firmware.

What can I do to make this adaptor work? Only add that v:p pair to ar5523.c and recompile it? Just if that can be done without compiling - it will be great.

Regards,
Dmitry.

