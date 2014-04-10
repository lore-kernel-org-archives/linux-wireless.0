Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pegasos-out.vodafone.de ([80.84.1.38]:50191 "EHLO
	pegasos-out.vodafone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933057AbaDJOmh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 10:42:37 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by pegasos-out.vodafone.de (Rohrpostix2  Daemon) with ESMTP id 8D5CE6400C7
	for <linux-wireless@vger.kernel.org>; Thu, 10 Apr 2014 16:42:35 +0200 (CEST)
Received: from pegasos-out.vodafone.de ([127.0.0.1])
	by localhost (rohrpostix2.prod.vfnet.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Nonl0v9bYf6d for <linux-wireless@vger.kernel.org>;
	Thu, 10 Apr 2014 16:42:30 +0200 (CEST)
Date: Thu, 10 Apr 2014 16:42:29 +0200 (CEST)
From: Stefan =?utf-8?Q?Kr=C3=BCger?= <01727988324@vodafone.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Abdulla Alwabel <abdulla.wabel@gmail.com>
Message-ID: <1629266394.17443508.1397140949916.JavaMail.root@vodafone.de> (sfid-20140410_164242_022701_5B35002B)
In-Reply-To: <5346099B.7090309@lwfinger.net>
Subject: Re: RTL8192ee Driver
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Larry, 


thanks for you response! 
Yesterday i tried this driver https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1239578/+attachment/4057550/+files/rtl_92ce_92se_92de_8723ae_88ee_8723be_92ee_linux_mac80211_0017.1016v2.2013.tar.gz 
and install it on my debian-system with Kernel 3.13.. 
after a reboot i see the wlan0 


but if i connect to my router the authentication failed, and after a few minutes the driver goes crazy, and fill up my logs (>300MB in a few seconds) with the following messages 

syslog; kern.log: 
Apr 9 16:51:25 wheezy kernel: [ 2545.626630] rtlwifi-0:_rtl_pci_interrupt():<10000-1> rx descriptor unavailable! 
Apr 9 16:51:25 wheezy kernel: [ 2545.626634] skb->end - skb->tail = 16000, len is 16301 
Apr 9 16:51:25 wheezy kernel: [ 2545.626651] rtlwifi-0:_rtl_pci_interrupt():<10000-1> rx descriptor unavailable! 
Apr 9 16:51:25 wheezy kernel: [ 2545.626656] skb->end - skb->tail = 16000, len is 16301 
Apr 9 16:51:25 wheezy kernel: [ 2545.626672] rtlwifi-0:_rtl_pci_interrupt():<10000-1> rx descriptor unavailable! 
Apr 9 16:51:25 wheezy kernel: [ 2545.626677] skb->end - skb->tail = 16000, len is 16301 
Apr 9 16:51:25 wheezy kernel: [ 2545.626694] rtlwifi-0:_rtl_pci_interrupt():<10000-1> rx descriptor unavailable! 
Apr 9 16:51:25 wheezy kernel: [ 2545.626700] skb->end - skb->tail = 16000, len is 16301 
Apr 9 16:51:25 wheezy kernel: [ 2545.626717] rtlwifi-0:_rtl_pci_interrupt():<10000-1> rx descriptor unavailable! 
Apr 9 16:51:25 wheezy kernel: [ 2545.626722] skb->end - skb->tail = 16000, len is 16301 


and 

messages: 
Apr 9 16:51:24 wheezy kernel: [ 2543.779541] skb->end - skb->tail = 16000, len is 16301 
Apr 9 16:51:24 wheezy kernel: [ 2543.779564] skb->end - skb->tail = 16000, len is 16301 
Apr 9 16:51:24 wheezy kernel: [ 2543.779586] skb->end - skb->tail = 16000, len is 16301 
Apr 9 16:51:24 wheezy kernel: [ 2543.779608] skb->end - skb->tail = 16000, len is 16301 


that is just a information for you ;) maybe it will help you to get this driver working. 


best regards 
Stefan 


----- Ursprüngliche Mail ----- 

Von: "Larry Finger" <Larry.Finger@lwfinger.net> 
An: "Abdulla Alwabel" <abdulla.wabel@gmail.com>, "stefan krueger" <stefan.krueger@vodafone.de> 
CC: "linux-wireless" <linux-wireless@vger.kernel.org> 
Gesendet: Donnerstag, 10. April 2014 05:01:47 
Betreff: Re: RTL8192ee Driver 

On 04/09/2014 09:41 PM, Abdulla Alwabel wrote: 
> Hi Larry, 
> I found a message from you in a mailing list saying you received code for driver 
> rtl8192ee. I've a lenovo laptop that has this chip and I couldn't find a stable 
> driver. Would you please help me by telling where can I find the code ? 

Abdulla and Stefan, 

My announcement was a bit premature. I am currently merging that driver with the 
rest of the rtlwifi family. I hope to have it working by next week. I will send 
kernel patches to everyone that has requested a copy. 

When those are ready, they will be patches that apply to the latest kernel 
(3.14). I hope that will not be a problem for either of you. 

Larry
