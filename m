Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:42145 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbZJURSw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2009 13:18:52 -0400
Received: by ewy3 with SMTP id 3so6275594ewy.17
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2009 10:18:56 -0700 (PDT)
Message-ID: <4ADF4285.7010405@gmail.com>
Date: Wed, 21 Oct 2009 20:19:01 +0300
From: Janne Tanskanen <jannejt@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: rt2500pci master mode and hostapd
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi! I build a wireless access point using a-link wl54pc (pcmcia card, 
rt2500pci module) and hostapd 0.6.9 with kernel version 2.6.32-rc5. 
Problem is that even tho hostapd starts and iwconfig shows wlan0 in 
master mode, other computers cant find the wireless network.

I found a working patch from here: 
http://rt2x00.serialmonkey.com/phpBB/viewtopic.php?p=32632#p32632 and 
all works now with it applied to vanilla kernel. Just wanted to post 
this to the mailing list and ask why it's not added to mainline rt2x00 
kernel tree yet? Patch on forum is from May, almost half year ago. 
Hopefully it'll be included to mainline kernel asap.

--
Janne Tanskanen
