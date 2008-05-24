Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:46502 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbYEXJYo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 May 2008 05:24:44 -0400
Received: by rv-out-0506.google.com with SMTP id l9so1281659rvb.1
        for <linux-wireless@vger.kernel.org>; Sat, 24 May 2008 02:24:43 -0700 (PDT)
Message-ID: <41c7306f0805240224o21341f8gdf7b70e657c003c1@mail.gmail.com> (sfid-20080524_112447_780312_E20EA1FD)
Date: Sat, 24 May 2008 11:24:43 +0200
From: "Joris van der Kwast" <jvdkwast@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: error on make
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I was trying to build the daily snapshot compat-wireless-2008-05-24,
on fedora 8, kernel 2.6.24.7-92.fc8_x86_64 and got the following
error:


/home/joris/Data/Downloads
/compat-wireless-2008-05-24/drivers/net/wireless/rt2x00/rt2x00leds.c:
In function 'rt2x00leds_register':
/home/joris/Data/Downloads/compat-wireless-2008-05-24/drivers/net/wireless/rt2x00/rt2x00leds.c:186:
error: 'struct led_classdev' has no member named 'blink_set'
/home/joris/Data/Downloads/compat-wireless-2008-05-24/drivers/net/wireless/rt2x00/rt2x00leds.c:189:
error: 'struct led_classdev' has no member named 'blink_set'
make[4]: *** [/home/joris/Data/Downloads/compat-wireless-2008-05-24/drivers/net/wireless/rt2x00/rt2x00leds.o]
Error 1
make[3]: *** [/home/joris/Data/Downloads/compat-wireless-2008-05-24/drivers/net/wireless/rt2x00]
Error 2
make[2]: *** [/home/joris/Data/Downloads/compat-wireless-2008-05-24/drivers/net/wireless]
Error 2
make[1]: *** [_module_/home/joris/Data/Downloads/compat-wireless-2008-05-24]
Error 2
make[1]: Leaving directory `/usr/src/kernels/2.6.24.7-92.fc8-x86_64'
make: *** [modules] Error 2


So I hope this helps.

--
Joris
