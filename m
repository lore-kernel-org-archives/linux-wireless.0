Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.237]:33418 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbZBDSKh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 13:10:37 -0500
Received: by qb-out-0506.google.com with SMTP id q18so414387qba.17
        for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2009 10:10:36 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 4 Feb 2009 23:40:36 +0530
Message-ID: <cf70f0210902041010h24932f9ao3e5c9f6a243b483d@mail.gmail.com> (sfid-20090204_191043_187718_E3A67F45)
Subject: Regarding Belkin wireless USB adapter
From: Shivdas Gujare <shivdas.tech@gmail.com>
To: hintak.leung@gmail.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I am trying to use Belkin Wireless G USB adapter(uses trl8187 driver)
on ARM board. I am tesing this with x86 and ARM board (BeagleBoard).

My problem is, this adapter works fine with my Ubuntu
laptop(v2.6.29-rc2) using NetworkManager because of udev.

I tried to run wpa_supplicant from command line as,
 wpa_supplicant -Dwext -iwlan0 -c/etc/wpa_supplicant.conf
It gives error "Failed to read or parse configuration
'/etc/wpa_supplicant.conf'"
Because, my laptop doesn't have /etc/wpa_supplicant.conf file, But
still wireless network works fine.

I don't have wpa_supplicant in ARM rootfs, hence want to know
Does wpa_supplicant is necessary to make this USB wireless adapter work?

Also, is /etc/wpa_supplicant.conf necessary in rootfs, since device
works fine without this file on my laptop.

Thanks for your help.

Regards,
Shivdas
