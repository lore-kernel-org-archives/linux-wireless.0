Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:34522 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756977AbYGFShF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2008 14:37:05 -0400
Message-ID: <487110CE.3050304@lwfinger.net> (sfid-20080706_203709_427507_FEDD413F)
Date: Sun, 06 Jul 2008 13:37:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: David Ellingsworth <david@identd.dyndns.org>
CC: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: b43legacy: local packet loss
References: <30353c3d0807061106x78e796f4r95f2ce7e56a4bb5c@mail.gmail.com>
In-Reply-To: <30353c3d0807061106x78e796f4r95f2ce7e56a4bb5c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Ellingsworth wrote:
> While using the latest b43legacy driver, I have severe packet loss
> originating from the machine using the b43legacy driver. However, when
> packets are routed through the machine using NAT, no packet loss
> occurs. Ping results are as follows:
> 
> using 'ping -c 100 192.168.1.1'
> 
>>From local machine (192.168.1.100) to wireless router (192.168.1.1)
>     43% packet loss, average rtt 13.987ms
> 
>>From nat machine(192.168.2.100) to wireless router (192.168.1.1) via
> b43legacy router(eth0:192.168.2.1, wlan0:192.168.1.100)
>     0% packet loss, average rtt 3.621ms
> 
> The only logical conclusion I can draw from the above information is
> that there is something wrong with how packets are created locally and
> delivered to the device. I'm willing to provide any help necessary
> needed to correct the issue.

More information please.

1. Is your "latest b43legacy" from wireless-testing, 2.6.26-rc9, or what?

2. What BCM43xx card are you using?

3. What wireless router are you using?

Using the wireless-testing git tree with a BCM4306/2 and working with a Linksys 
WRT54GL router with standard firmware, my statistics for the ping -c 100 
192.168.1.1 command are 0% packet loss with average rtt of 2.919 ms.

Larry
