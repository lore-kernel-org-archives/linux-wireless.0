Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from swm.pp.se ([212.247.200.143]:55416 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab3C2L7I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Mar 2013 07:59:08 -0400
Received: from localhost (localhost [127.0.0.1])
	by uplift.swm.pp.se (Postfix) with ESMTP id C87A89A
	for <linux-wireless@vger.kernel.org>; Fri, 29 Mar 2013 12:50:15 +0100 (CET)
Date: Fri, 29 Mar 2013 12:50:15 +0100 (CET)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: linux-wireless@vger.kernel.org
Subject: problems with iwlwifi - intel 5300 - 5GHz - all versions
Message-ID: <alpine.DEB.2.00.1303291240580.11255@uplift.swm.pp.se> (sfid-20130329_125912_861782_76767C3D)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello.

I have been running Ubuntu since 8.10 on my Thinkpad X200. Over the years, 
my wifi has been problematic with linux, but the past year or so it's 
generally been working well. However, lately I ran into a regression with 
a stable rebuild of 3.2 (-35 in ubuntu-land).

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1096294

The information here is generally a bit low on detail because I have 
little idea how to collect information suitable for meaningfull debugging.

Short: 3.2 gained a regression about 2 months ago. I usually solved 
this by rebooting the AP or doing rmmod/modprobe iwlwifi, or rebooting 
into 3.8.0 and then booting back into 3.2.0-34.

Then when I tried -39, my 5GHz wifi stopped working completely (would only 
stay associated for a few seconds, then disconnect with local reason 3), 
tried rebooting the AP, same thing. I tried 3.8.0 which worked before, it 
behaved the same way. I also tried 3.9-rc4, same result. So now I was 
without 5GHz for a 1-2 weeks, running only on 2.4GHz.

Then I installed and booted into Win8 to verify my hardware. Worked fine 
with 5GHz. Then I booted back into 3.2.0-34, which then all of a sudden 
worked fine, and now I am on 3.2.0-39 which is also fine.

Is there anything in Intel 5300 that can survive between cold boots that 
booting into Win8 might magically fix, especially something that might 
have been touched by recent changes in 3.2 stable and 3.8-3.9 ?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
