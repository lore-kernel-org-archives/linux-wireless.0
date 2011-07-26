Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:2609 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab1GZTRR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 15:17:17 -0400
Message-ID: <4E2F12A3.1020600@gnu.org> (sfid-20110726_211720_896212_6B0BE1A2)
Date: Tue, 26 Jul 2011 15:16:51 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: Stephen Agyepong <stephenagyepong@gmail.com>
CC: ilw@linux.intel.com, linux-wireless@vger.kernel.org
Subject: Re: Intel 6250 AGN AP
References: <CAEMBq35XfkBiwmBQyLi_cwvZVa6GEp_9ZKryrYmqK9Y5yp=+bQ@mail.gmail.com>
In-Reply-To: <CAEMBq35XfkBiwmBQyLi_cwvZVa6GEp_9ZKryrYmqK9Y5yp=+bQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

Please use non-empty subject for new mailing list posts.  I'm adding one 
for you.

Also, it's a bad style to post support questions directly to the 
developers it there is a mailing list, so I'm removing that address from 
the CC.

On 07/26/2011 02:28 PM, Stephen Agyepong wrote:
> I have an HP Pavilion g6-1b79dx  (64-bit) with the ff specs:
>
> intel core i3-370M processor (2.4 GHz)
> 500 GB hard drive
> 4096 MB DDR3 SDRAM
> DVD Optical Drive
> 15.6 diagonal HD brghtview LED display

That's really irrelevant to the issue :)

> WLAN
>
> Intel centrino advanced-n 6250 AGN
> Intel centrino WiMAX 6250
>
> I have installed Centos 6. Things seem to work okay except
> the wireless card. Linux (centos 5.6/6, fedora 14/15) dont seem to
> recognize the wireless access point.

Please give details what exactly you are seeing and what the basis for 
your interpretation is.

Before trying the AP function, please make sure that the card is 
supported at all, perhaps as a station.  It should be supported, as 
Intel 6250 AGN is supported since Linux 2.6.35.  But you may want to try 
compat-wireless to make sure you are using the latest driver.

> Windows 7 is able to see it with no problems. But I want to run only
> linux on this system.
>
> I have run hostapd, iw, etc. They all say nl80211 is not found. I
> have search everywhere and dont seem to be able to find out how to
> get nl80211 on my centos system. I will be willing to switch to a distribution
> that is able to get my laptop to recognize my WAP.

Please post the exact commands you are running and don't rephrase error 
messages.  Give others a chance to see what you are doing or 
interpreting incorrectly.

If some program gives you an error, please always give the version 
number of that program.  Also, the kernel version is relevant here, as 
the drivers are part of the kernel.

-- 
Regards,
Pavel Roskin
