Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:35747 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbYIZQaa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 12:30:30 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KjGD6-00052x-Et
	for linux-wireless@vger.kernel.org; Fri, 26 Sep 2008 16:30:28 +0000
Received: from 77.21.175.82 ([77.21.175.82])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 26 Sep 2008 16:30:28 +0000
Received: from feldmann_markus by 77.21.175.82 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 26 Sep 2008 16:30:28 +0000
To: linux-wireless@vger.kernel.org
From: feldmaus <feldmann_markus@gmx.de>
Subject: Re: Do not get BCM4303 to work
Date: Fri, 26 Sep 2008 18:32:40 +0200
Message-ID: <gbj2mr$fp6$1@ger.gmane.org> (sfid-20080926_183033_247956_E9A0F6A9)
References: <ga2fra$9q$1@ger.gmane.org> <48C5777B.9070106@lwfinger.net> <gaesbd$nv8$1@ger.gmane.org> <48CB0993.6020601@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
In-Reply-To: <48CB0993.6020601@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger schrieb:
> feldmaus wrote:
>> Larry Finger schrieb:
>>> Your card can receive, but not transmit due to a problem with the 
>>> rfkill switch handling in b43legacy. I'm working on this problem with 
>>> a Ubuntu user, and will post patches as soon as the problem is fixed.
>>>
>>> Larry
>> Thanks for your Support.
>>
>> I installed the Kernel 2.6.26-1 as Maximilian said.
>> I hope i can try to get my Card to work.
>> If you need some Messages then let me know.
> 
> The Ubuntu user and I have discovered that his computer needs the hp-dmi 
> module that is part of the mainline kernel since 2.6.27-rc6. This module 
> handles the rfkill button that does not produce a scancode. I think you 
> will need to get that one for you to be able to turn the radio on.
So the hp-dmi Module is only available in 2.6.27 ?

Regards feldmaus

