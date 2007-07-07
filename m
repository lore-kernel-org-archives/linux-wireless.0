Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:34659 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753705AbXGGSIw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jul 2007 14:08:52 -0400
Message-ID: <468FD6B2.6000408@lwfinger.net>
Date: Sat, 07 Jul 2007 13:08:50 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Errors when firmware is missing
References: <9e4733910707070927l37bdf79cpd1fc672909fb0bb3@mail.gmail.com>
In-Reply-To: <9e4733910707070927l37bdf79cpd1fc672909fb0bb3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jon Smirl wrote:
> I have a new Broadcom 4318 adapter (which has exactly the same issues
> with promiscuous mode). I didn't have the right firmware down for it
> and I received this error message when I did "ifconfig wlan up"
> SIOCSIFFLAGS: No such file or directory.  This is not the most user
> friendly error message, but I did receive a log entry.

If the firmware did not load correctly, the bcm43xx driver logs appropriate messages. This error 
would have been encountered and logged when the interface was brought up. Is that what you meant 
when you say that you received a log entry? The ifconfig error message is output by the user code, 
and is not controlled by any driver.

For me, the BCM4318 works in promiscuous mode. I regularly use both the 4318 and a 4311 with Kismet 
for testing. What kernel version were you using? If older than 2.6.21, was it patched?

Larry

