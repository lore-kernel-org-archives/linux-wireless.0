Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.221.174]:41019 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbZJZPRG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 11:17:06 -0400
Received: by qyk4 with SMTP id 4so7708815qyk.33
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 08:17:10 -0700 (PDT)
Message-ID: <4AE5BD6C.2050303@gmail.com>
Date: Mon, 26 Oct 2009 11:17:00 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: rtl8187: kernel oops when leds enabled
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using kernel 2.6.31 and compat-wireless stable 2.6.32_rc5 I get this 
kernel oops nearly 100% of the time when I unplug the device.  I have 
tried with the device down, up, and while transmitting, here are the 
three oopses.  Sorry it took me so long for this report, it is an odd 
bug.  When I was running older kernel/compat-wireless this oops was 
about 4-5 screens longs so I couldn't take a picture.  Additionally I 
took the advice of a few of the list members to try the crashkernel 
feature (which is AWESOME  btw) but it doesn't work for this oops.  Let 
me be more specific, I can trigger an oops and the crash kernel kicks 
in, but with this oops the crash kernel never kicks in so I am guessing 
this is bad news.

I'm honestly a little surprised that no one has bothered to reproduce 
this in the month since I reported it but maybe it is more unique to my 
setup than it seems.

Hope these pictures are readable enough to be useful.

http://picpaste.com/pics/cimg1470.1256404028.jpg
http://picpaste.com/pics/cimg1474.1256404126.jpg
http://picpaste.com/pics/cimg1477.1256404170.jpg

I can fairly well generate this error at will and I'm available to test 
reproducing the bug in any possible situation which is suggested and/or 
test patches to fix.

Thanks,
Rick

