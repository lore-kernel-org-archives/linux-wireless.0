Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:37703 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaKKLWR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 06:22:17 -0500
Message-ID: <5461F165.1010801@broadcom.com> (sfid-20141111_122224_639450_A7BADEF9)
Date: Tue, 11 Nov 2014 12:22:13 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Efill <efill@me.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: (Intel Wireless 7260) + 5G + AP mode
References: <fd333f5e-227c-4c48-a8ba-14102e26599d@me.com>
In-Reply-To: <fd333f5e-227c-4c48-a8ba-14102e26599d@me.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11-11-14 11:54, Efill wrote:
>  >>>>>> I’m trying to get the 7260 to act as an AP on the 5G band. Unfortunately 
> it seems to be impossible due to the „no IR“ reg domain restriction done by the 
> Intel >firmware internally (this is what I’ve googled so far..).
>  >>>>>>
>  >>>>>> Could someone explain to me the technical background of this. As far as 
> I understood the regulation if DFS and TPC are used, most of the 5G channels are 
> allowed. >Did I miss something? What’s the point of restricting the IR then?
>  >>>>
>  >>>> This is not true world wide. With the devices currently available, you
>  >>>> can't have IR in 5GHz.
>  >>>>
>  >>
>  >> Even so I don't want to teach you wrong, a quick look at wikipedia reveals a 
> slightly different view on this:
>  >> 
> https://en.wikipedia.org/wiki/List_of_WLAN_channels#5.C2.A0GHz_.28802.11a.2Fh.2Fj.2Fn.2Fac.29.5B17.5D 
> 
>  >>
>  >> I mean that's exactly what's the linux kernel reg domain stuff ( 
> http://wireless.kernel.org/en/developers/Regulatory/processing_rules ) is meant 
> to manage, isn't it?
>  >>
>  >>> Let me clarify, with *Intel* devices currently available, you will not
>  >>> be able to have IR in 5GHz.
>  >>
>  >> That's the reason I wrote the mail in the first place. I wasn't able to use 
> AP mode at 5G. Wich I found out by myself and didn't read somewhere e.g. at 
> http://>wireless.kernel.org/en/users/Drivers/iwlwifi . If it's that clear and 
> obvious, why not state it there? I would have saved me 50 Euros and some hours...
>  >>
>  >> Just a feeling, but I guess asking something like "Why?" wouldn't help me in 
> understanding, right? This is just some marketing decision at Intel (don't 
> support 5G AP >mode in consumer WiFi cards) developers have to follow.
>  >>
>  >>
>  >>>>>
>  >>>>> And finally: Is there a way to get it work? Some other PCI-E chip? ath10k?
>  >>
>  >> Does anyone have a working setup for 5G AP mode with linux using a 
> (m)PCI(-e) card? Or are there only SoCs available for this job?
>  >
>  > Well, I have although I would have no idea where you could buy it. As
>  > you may guess it is a Broadcom device and comes with my job.
> 
> Dear Arend,
> 
> thanks for acknowledging that at least it's possible ;-) Do you mind releasing 
> slightly more information on this? Which chip, connectivity, packaging etc. I've 
> tried the Broadcom BCM4360 but had to learn that this one is lacking AP mode 
> completely...

Currently, I am using BCM4354 and BCM43602. The BCM4360 is a softmac
device and the Broadcom wl driver might indeed lack AP support.

Regards,
Arend

> Another question: Did someone had luck getting an Atheros QCA9880 V2 to work as 
> an 802.11ac 5G AP?
> 
> 
> Best,
> Efill
> 
> 

