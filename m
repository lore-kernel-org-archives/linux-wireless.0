Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:60173 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab0AEXB5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 18:01:57 -0500
Received: by yxe26 with SMTP id 26so16126781yxe.4
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2010 15:01:56 -0800 (PST)
Message-ID: <4B43C496.4040609@gmail.com>
Date: Tue, 05 Jan 2010 15:00:38 -0800
From: John Daiker <daikerjohn@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: bcm43xx-dev@lists.berlios.de
Subject: b43: must set qos=0 on to connect
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a BCM4312 rev 01 (14e4:4315) card in my HP Mini netbook.  I am 
having troubles connecting to any WEP secured AP.

I know the trick about having to load with pio=1 for the device to stay 
happy (and forget about using DMA), so no issues there, I hope.

With qos=1 (by default, IIRC), I am unable to establish a connection 
with said WEP connection, and notice many 'PHY transmission error' 
messages in my dmesg output.

With qos=1, I can successfully connect to my WEP connection without 
issue, and without any error messages or warnings.

I have a BCM4318 rev 02 (14e4:4318) in a desktop that works with 
enabled/disabled qos not matter what.  Also, a RT2500-based card works 
fine on the connection as well.

Both card are using the 478.104 firmware.

Please advise what steps I should take to further debug this issue.

Thanks,
John Daiker
