Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:37149 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752482Ab0LUSug (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 13:50:36 -0500
Subject: Re: WL1271
From: "David Lynch Jr." <dhlii@dlasys.net>
To: Elvis Dowson <elvis.dowson@mac.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4CC0832C-93B4-4212-BB5C-1901BB6A63D7@mac.com>
References: <0826983CC0CB074798C42E77D8ACD07F01AE4A@pdtms1.pdt.com>
	 <1292843841.13129.9.camel@chilepepper>
	 <0826983CC0CB074798C42E77D8ACD07F01AEA8@pdtms1.pdt.com>
	 <1292879085.20560.6.camel@t-dhlii>
	 <4CC0832C-93B4-4212-BB5C-1901BB6A63D7@mac.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Dec 2010 13:50:33 -0500
Message-ID: <1292957433.20560.109.camel@t-dhlii>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	I am essentially doing exactly the same thing as you are - but I am a
few days behind you. I noted a post of yours about 10 days ago in
linux-omap that you were having voltage/SDIO detection problems. I am
having exactly that problem at this moment.  
	How did you work arround it ?
	The WL1271 is attached to MMC2 on my system. All the examples in the
linux wireless tree are on SPI or MMC3. But I think I managed changing
things correctly - except that the error reports are mmc1:
	Also the comments suggest that the WL1271 has its own internal voltage
regulation. 
	That and a CY8CTMG-200 touch screen are the only major items I need
working to polish off this project. 


On Tue, 2010-12-21 at 01:31 +0400, Elvis Dowson wrote:
> Hi,
> 
> On Dec 21, 2010, at 1:04 AM, David Lynch Jr. wrote:
> 
> > 	I am looking to get the TI WL1271 WiFi working in an Android Froyo
> > system. 
> > 	I have Linux kernel experience including network and wifi drivers. 
> > 	I am gathering that there are atleast two different efforts to support
> > the TI1271 one based on the normal Linux kernel development process and
> > one that seems to be part of the TI Android community. 
> > 	Can anyone comment on the relative merits of these approaches ?
> > 
> > 	Is it reasonable to assume that if I add the WL1271 to the Android
> > 2.6.32 kernel tree using compat-wireless that it will properly integrate
> > with Android ? If not could someone point me towards resources specific
> > to Android's wireless implimentation ?
> 
> I too am working on the very same subject, which is to get the Murata
> TI WL1271 chip working with Android 2.2.1.
> 
> Chip integration with the board was verified using the mainline wl1271
> drivers (linux-2.6.37-rc6). 
> 
> With the proprietary TI drivers, I ran into issues getting it to work with my platform
> so, while that issue is being addressed, in parallel, I am going to try to use
> the compat-wireless package to get wl1271 working with android-2.6.32 and
> android-2.2.1.
> 
> The only issue I see is I'm not sure if the mainline wl1271 driver currently supports
> the android specific wireless commands, and its integration with wpa_supplicant
> WEXT driver in the android repo. One could use the AWEXT wrapper core, in this
> case, but it is something that I need to see once I get to that stage, in a couple of days.
> 
> Elvis Dowson
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

