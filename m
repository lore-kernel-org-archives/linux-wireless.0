Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.highlandsun.com ([70.87.222.79]:58370 "EHLO
	mail.highlandsun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757864AbZEOJsv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 05:48:51 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.highlandsun.com (Postfix) with ESMTP id 2DA6110F8E
	for <linux-wireless@vger.kernel.org>; Fri, 15 May 2009 05:48:52 -0400 (EDT)
Message-ID: <4A0D3A83.4040809@highlandsun.com>
Date: Fri, 15 May 2009 02:48:51 -0700
From: Howard Chu <hyc@highlandsun.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: orinoco_cs and WPA-EAP?
References: <4A065AFD.8000604@highlandsun.com>
In-Reply-To: <4A065AFD.8000604@highlandsun.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sigh, nothing's ever easy. After abandoning the CTX714 I mentioned in an 
earlier email, I find that the Thinkpad T42 I got from eBay came with some 
kind of Orinoco 802.11B mini-PCI card installed. Ubuntu Jaunty's 2.6.28 kernel 
loads up the orinoco_cs driver for this card. It appears that this driver only 
supports WPA-PSK, and I use WPA-EAP on my home wlan. Has anyone done any work 
on supporting WPA-EAP for this card?

As an exercise in futility, I also built a wlags49-h1-cs driver and 
wpa_supplicant-0.6.9 with Hermes driver support. After patching it all to 
compile and run on my 2.6.28 kernel, I found that it also only supports 
WPA-PSK. I'm going to guess that this was obviously a waste of time and these 
patches aren't interesting/useful going forward, since the original Lucent 
code is so ancient...

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
