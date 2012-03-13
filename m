Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56852 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965046Ab2CMKPt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 06:15:49 -0400
Message-ID: <4F5F1E53.3000506@openwrt.org> (sfid-20120313_111553_004974_75A2F68B)
Date: Tue, 13 Mar 2012 11:15:47 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Nikodem Ciesielski <nikodem.ciesielski@microgen.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: 4addr explanation
References: <4F5E658B.9060503@microgen.com>
In-Reply-To: <4F5E658B.9060503@microgen.com>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-03-12 10:07 PM, Nikodem Ciesielski wrote:
> Hello
> 
> The question is:
> Does 4addr mode require that wireless device to support WDS mode?
> 
> I'm trying to achive the following:
> - bridge wire and wireless interface (Broadcom BCM43224) on Dell Latitude E6510
>   os: Ubuntu 11.10 with  iw 3.3 (compiled and installed)
> - setting wireless interface to 4addr mode and managed mode
> - connect to Asus RT-n16 (firmware: TomatoUSB by shibby 1.28.0000 MIPSR2-085V K26 USB AIO)
> *- * setting router to AP+WDS mode and add Laptop wireless MAC to WDS device
> 
> Simply I want to bridge wireless and wire intterface to work like an ordinary (wire) ethernet bridge.
> And I can't. I followed the instrucion from:
> http://nullroute.eu.org/~grawity/not-a-blog.html
> topic: VirtualBox bridged network and WLAN
> 
> I think that my router refuse 4addr packages but I'm not sure.
> Broadcom BCM43224 does not support WDS mode,
> however it seems that 4addr mode can be set
> and the wirelass card is able to assing with the router.
> What can I do?
mac80211 4addr mode is incompatible with the Broadcom specific WDS mode
implemented in your router.

- Felix
