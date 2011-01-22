Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f66.google.com ([209.85.161.66]:37124 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab1AVOuE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Jan 2011 09:50:04 -0500
Received: by fxm14 with SMTP id 14so1509093fxm.1
        for <linux-wireless@vger.kernel.org>; Sat, 22 Jan 2011 06:50:03 -0800 (PST)
Message-ID: <4D3AEE9C.4060306@googlemail.com>
Date: Sat, 22 Jan 2011 15:50:04 +0100
From: Kassandra Drowner <kassandra.drow@googlemail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: The future of ACX100/ACX111/TNETW1450 support in the kernel?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm using a AVM Fritz Wlan Stick of the first generation. This USB 
device has the TNETW1450 by Texas Instruments.
According to the ubuntu-wikipage this is one device that needs to be 
handled with ndiswrapper & the windows driver , because no kernel driver 
is available.

I searched around and came across http://acx100.sourceforge.net/ . This 
driver isnt merged obviously because of legal problems with the 
developing process.

In the LWN Article "Who wrote 2.6.37" ( http://lwn.net/Articles/420658/ 
) i've seen the chipset manufacturer Texas instruments being ranked 
quite high up.

Are there plans to get official support for the chipsets 
ACX100/ACX111/TNETW1450 in the mainline tree one day, now that the 
manufacturer has started to work on linux-support? Will the legal issues 
be dealt with, so the sf-project can be included and the driver being 
worked on by more people than just 2 or 3 ?


Kassandra Drowner
