Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:59737 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbYJaIls (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 04:41:48 -0400
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Message-Id: <DAD31980-B029-46D4-A687-9B0426899853@holtmann.org> (sfid-20081031_094155_311410_C5C63BA6)
From: Marcel Holtmann <marcel@holtmann.org>
To: Marcel Holtmann <holtmann@linux.intel.com>
In-Reply-To: <5A6314C4-958B-43E7-B94D-FE5BABED89EA@linux.intel.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: Still 4965 issues with wireless-testing
Date: Fri, 31 Oct 2008 09:41:43 +0100
References: <5A6314C4-958B-43E7-B94D-FE5BABED89EA@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi again,

> so besides the point that the Ubuntu 8.10 kernel has a broken driver  
> for the Intel 4965 cards which will crash my X61 after less than one  
> minute uptime when it connects to my access point, I have my dmesg  
> full with warnings from the latest wireless-testing kernel.
>
> I know that we have discussed this before and Johannes' patch at  
> least turns it into warnings instead of killing my system  
> completely, but I am still surprised why this hasn't been fixed.

so this becomes more and more annoying. I get this WARN_ON now  
multiple times pre minute. Only the first few minutes after loading  
the firmware everything is okay and then it keeps filling my dmesg.  
And on top of that, I now see these:

__ratelimit: 1189 callbacks suppressed
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
__ratelimit: 57695 callbacks suppressed
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers
__ratelimit: 3345 callbacks suppressed
iwlagn: Can not allocate SKB buffers
iwlagn: Can not allocate SKB buffers

What is going on here? This is a normal setup and nothing fancy.  
Access point is N-Capable from D-Link btw.

Regards

Marcel

