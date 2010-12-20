Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from asmtpout027.mac.com ([17.148.16.102]:58646 "EHLO
	asmtpout027.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab0LTVb4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 16:31:56 -0500
MIME-version: 1.0
Content-type: text/plain; CHARSET=US-ASCII
Received: from [192.168.1.30] ([87.201.169.175])
 by asmtp027.mac.com (Oracle Communications Messaging Exchange Server 7u4-18.01
 64bit (built Jul 15 2010)) with ESMTPSA id <0LDQ00E1BX52LG10@asmtp027.mac.com>
 for linux-wireless@vger.kernel.org; Mon, 20 Dec 2010 13:31:55 -0800 (PST)
Subject: Re: WL1271
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <1292879085.20560.6.camel@t-dhlii>
Date: Tue, 21 Dec 2010 01:31:39 +0400
Cc: linux-wireless@vger.kernel.org
Message-id: <4CC0832C-93B4-4212-BB5C-1901BB6A63D7@mac.com>
References: <0826983CC0CB074798C42E77D8ACD07F01AE4A@pdtms1.pdt.com>
 <1292843841.13129.9.camel@chilepepper>
 <0826983CC0CB074798C42E77D8ACD07F01AEA8@pdtms1.pdt.com>
 <1292879085.20560.6.camel@t-dhlii>
To: "David Lynch Jr." <dhlii@dlasys.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Dec 21, 2010, at 1:04 AM, David Lynch Jr. wrote:

> 	I am looking to get the TI WL1271 WiFi working in an Android Froyo
> system. 
> 	I have Linux kernel experience including network and wifi drivers. 
> 	I am gathering that there are atleast two different efforts to support
> the TI1271 one based on the normal Linux kernel development process and
> one that seems to be part of the TI Android community. 
> 	Can anyone comment on the relative merits of these approaches ?
> 
> 	Is it reasonable to assume that if I add the WL1271 to the Android
> 2.6.32 kernel tree using compat-wireless that it will properly integrate
> with Android ? If not could someone point me towards resources specific
> to Android's wireless implimentation ?

I too am working on the very same subject, which is to get the Murata
TI WL1271 chip working with Android 2.2.1.

Chip integration with the board was verified using the mainline wl1271
drivers (linux-2.6.37-rc6). 

With the proprietary TI drivers, I ran into issues getting it to work with my platform
so, while that issue is being addressed, in parallel, I am going to try to use
the compat-wireless package to get wl1271 working with android-2.6.32 and
android-2.2.1.

The only issue I see is I'm not sure if the mainline wl1271 driver currently supports
the android specific wireless commands, and its integration with wpa_supplicant
WEXT driver in the android repo. One could use the AWEXT wrapper core, in this
case, but it is something that I need to see once I get to that stage, in a couple of days.

Elvis Dowson
