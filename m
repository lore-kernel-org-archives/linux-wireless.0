Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.highlandsun.com ([70.87.222.79]:60687 "EHLO
	mail.highlandsun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbZEJFPP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 May 2009 01:15:15 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.highlandsun.com (Postfix) with ESMTP id 16E6E10F8E
	for <linux-wireless@vger.kernel.org>; Sun, 10 May 2009 00:41:35 -0400 (EDT)
Message-ID: <4A065AFD.8000604@highlandsun.com>
Date: Sat, 09 May 2009 21:41:33 -0700
From: Howard Chu <hyc@highlandsun.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: CTX714 to a good home
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
   I recently bought a Creatix CTX714 in the hopes of using it in a Thinkpad 
T23. After much experimentation I've been unable to get it working, and am 
giving up. I bought it for $8 on eBay, but the shipping (from Hong Kong to Los 
Angeles) was over $20 so it's not worthwhile for me to return it for a refund. 
I'd like to send it to any interested developer to wrestle with and see if 
they can get it working. lspci identifies it as 1260:3390, and the p54pci 
driver talks to it, but I was never able to see any APs with it.

More background: the T23 had a 56K modem in the mini-PCI slot. I wanted to 
find a combo wifi/modem card with 802.11g and V.90, and the CTX714 appeared to 
be the only candidate, so when I saw one on eBay, I jumped on it.

The card came with a mini-CDROM with a Windows driver. The driver included a 
fullmac firmware, 1.0.1.0. The Creatix docs say that this card uses the same 
chipset/driver as their CTX405 card. Their docs also said that the CTX405 
would only work using ndiswrapper on Linux. (There are barely any CTX714 docs.)

I've already gone thru all the motions of trying the 1.0.1.0 and 1.0.4.3 
firmware with the original prism54 driver, as well as just trying the default 
softmac firmware for the p54pci driver, and ndiswrapper with the Windows 
driver. (On Ubuntu Jaunty, 2.6.28.x kernel.) I've had absolutely no luck. The 
drivers see the device, register an interface, and they show the correct MAC 
address for the card, but I never see any other stations. In fact the card 
didn't work under Windows either, so possibly there's a problem with the card 
itself, but I don't know how to diagnose this any further. And possibly it 
just won't work in any Thinkpad. The eBay ad said it would only work in two 
models of Medion laptop. I could give it a try in my Asus laptop, but I don't 
want to spend any more time on it; I've bought a Thinkpad T42 (which comes 
with a wifi card) to replace the T23 and will be selling the T23. If you want 
this CTX714 and are willing to try to make it work, email me. I'll send it to 
the first responder.

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
