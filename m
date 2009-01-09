Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:52449 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbZAILL3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 06:11:29 -0500
Cc: linux-wireless@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>
Message-Id: <2DA5FF49-D67E-43CA-ACE5-FF530774A070@ing.unibs.it> (sfid-20090109_121133_008481_A444ADC0)
From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
To: Michael Buesch <mb@bu3sch.de>
In-Reply-To: <200901091158.48989.mb@bu3sch.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [b43] opensource firmware
Date: Fri, 9 Jan 2009 12:03:48 +0100
References: <200901091129.22708.mb@bu3sch.de> <200901091149.28683.mb@bu3sch.de> <200901091158.48989.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Damn! Our 4306 was a mini-pci card mounted on an adapter on a PCI bus.  
Remember to disable qos (qos=0 on module load). Could we have  
different initvals files? Our count

3e5442067f1c945e6180777728a2ea08  b0g0bsinitvals5.fw
f85142421a4a1bcb9dd52c513c1ea558  b0g0initvals5.fw

Finally, what kernel version are you using? We were out of sync since  
late october (stopped ad 2.6.27-rc5-wl)

Cheers,
-FG

On Jan 9, 2009, at 11:58 AM, Michael Buesch wrote:

> On Friday 09 January 2009 11:49:28 Michael Buesch wrote:
>> I'd like to start merging this into the "firmware" directory
>> of the mainline kernel.
>
> Ok, the code doesn't work on my 4306 hardware.
> So I think I'll not merge it into the kernel right away, but first  
> merge
> it into my b43-openfw git repository, that already partially works  
> on my hardware.
> That also gives the code an extra review.
>
> -- 
> Greetings, Michael.


