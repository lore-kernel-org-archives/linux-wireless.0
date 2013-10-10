Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:51986 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755430Ab3JJTEM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Oct 2013 15:04:12 -0400
Received: from [192.168.2.100] ([93.218.71.155]) by mail.gmx.com (mrgmx103)
 with ESMTPSA (Nemesis) id 0MCL6r-1VdO4R01Gz-009BHb for
 <linux-wireless@vger.kernel.org>; Thu, 10 Oct 2013 21:04:10 +0200
Message-ID: <5256FA29.9010307@rempel-privat.de> (sfid-20131010_210415_101583_F11E29C7)
Date: Thu, 10 Oct 2013 21:04:09 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Cedric VONCKEN <cedric.voncken@acksys.fr>,
	linux-wireless@vger.kernel.org
Subject: Re: ATH9K: CST interrupt issue
References: <773DB8A82AB6A046AE0195C68612A3190164B494@sbs2003.acksys.local>
In-Reply-To: <773DB8A82AB6A046AE0195C68612A3190164B494@sbs2003.acksys.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 10.10.2013 17:49, schrieb Cedric VONCKEN:
> I using the DNMA-H5 from unex and compat 2013-04-16. 
> 
> If the equipment with this card is placed in 30°C environment, with iperf I can send 150 Mbit/s.
>  
> If the equipment with this card is placed in 0°C environment my throughput is not stable and is around 40Mbit/s.
> In this condition, I receive some CST interrupt burst. If I correctly understand the ATH9K driver code, when this interruption occur the driver only increase the interrupt counter.
> 
> Have you any information on this interrupt ? I googled but I don't found any information.

CST - Carrier Sense Timeout.

> Do you know if the driver need a specific action to handle it ? If yes, could you give me some pointer to do that ?

I do not know. May be some body else knows.

> How I can increase the timeout Value ?  

See AR_CST_TIMEOUT_LIMIT, it should be in useconds.

> If I tried with other Wireless card (DNMA-83 from unex for example) I have not this problem.
> 
> Any help will be appreciated.


-- 
Regards,
Oleksij
