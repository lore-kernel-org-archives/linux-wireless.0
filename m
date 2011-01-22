Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4173 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab1AVQTl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Jan 2011 11:19:41 -0500
Message-ID: <4D3B0390.5070108@broadcom.com>
Date: Sat, 22 Jan 2011 17:19:28 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Jamie Kitson" <jamie@kitten-x.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Brett Rudley" <brudley@broadcom.com>
Subject: Re: Kernel Panic wlc_mac80211.c Line 6093
References: <AANLkTikam0zcxe00UCT4BDQMmrJcPKf1Hbt6=PBokpga@mail.gmail.com>
In-Reply-To: <AANLkTikam0zcxe00UCT4BDQMmrJcPKf1Hbt6=PBokpga@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jamie,

On 01/08/2011 01:37 AM, Jamie Kitson wrote:
> Hello,
>
> I've received the following kernel panic twice in two days since I
> started using the brcm80211 driver:
>
> http://farm6.static.flickr.com/5202/5334637544_a0dacd5edd_b.jpg
>
> I have a Dell M101z with:
>
> 03:00.0 Network controller: Broadcom Corporation BCM4313 802.11b/g/n
> Wireless LAN Controller (rev 01)
>
> I am running:
>
> Linux jamie-laptop 2.6.36-ARCH #1 SMP PREEMPT Fri Dec 10 20:32:37 CET
> 2010 x86_64 AMD Athlon(tm) II Neo K325 Dual-Core Processor
> AuthenticAMD GNU/Linux
>

Rereading the whole thread I noticed the PREEMPT in your uname message. 
Does this mean you are running with CONFIG_PREEMPT (Preemptible Kernel)? 
This may not be supported by this driver.

> Cheers, Jamie
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
Gr. AvS

