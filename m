Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:57563 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab3D0MCr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Apr 2013 08:02:47 -0400
Received: by mail-lb0-f169.google.com with SMTP id p10so564224lbi.28
        for <linux-wireless@vger.kernel.org>; Sat, 27 Apr 2013 05:02:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABH51ZYepRMcmW4wFUmOf9dcnB4X0X377mmwSXNo9AQGbsNAxA@mail.gmail.com>
References: <CABH51ZYepRMcmW4wFUmOf9dcnB4X0X377mmwSXNo9AQGbsNAxA@mail.gmail.com>
Date: Sat, 27 Apr 2013 05:02:46 -0700
Message-ID: <CABH51ZbDsx9hg9NtafyOk__62O=yO1sKkW2bf_DHEghSwSd=EQ@mail.gmail.com> (sfid-20130427_140300_619736_D93F42FA)
Subject: Fwd: RTL8192CU / Kconfig
From: Kris Reeves <myndzi@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Okay, please pardon me if I'm sending this to the wrong place, but
apparently people in no less than three channels on IRC are either
arrogant twats or I'm missing something extremely big that nobody felt
up to rubbing in my face...

This file:
https://github.com/raspberrypi/linux/blob/rpi-3.6.y/drivers/net/wireless/rtl8192cu/Kconfig

Should, I believe, include select statements for WIRELESS_EXT,
WEXT_PRIV, and (maybe?) WEXT_SPY (I added it preemptively after the
first two stopped compilation...)

The drivers won't compile without those options, but can be enabled in
situations where they are not set.

I realize this is the raspberry pi github page, but from what I can
tell, these files didn't originate there and this driver is in staging
on its way to mainline(?)

This file:
https://github.com/torvalds/linux/blob/master/drivers/net/wireless/rtlwifi/Kconfig

appears to be the equivalent and it doesn't look like it contains the
relevant lines. I'm uncertain if they are necessary here.

If you would, please inform me of the correct way to determine who I
should report something like this to and how! I know there are various
bugtrackers about but I can't seem to work out where I should go with
it.

Thanks for your time.
