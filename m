Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from st11p02mm-asmtpout001.mac.com ([17.172.220.236]:53513 "EHLO
	st11p02mm-asmtp001.mac.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750941AbaKJVb0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 16:31:26 -0500
Received: from [192.168.1.251] (i5E86D836.versanet.de [94.134.216.54])
 by st11p02mm-asmtp001.mac.com
 (Oracle Communications Messaging Server 7u4-27.10(7.0.4.27.9) 64bit (built Jun
  6 2014)) with ESMTPSA id <0NEU00D61EFTYKA0@st11p02mm-asmtp001.mac.com> for
 linux-wireless@vger.kernel.org; Mon, 10 Nov 2014 21:31:07 +0000 (GMT)
From: Efill <efill@me.com>
Content-type: text/plain; charset=windows-1252
Subject: (Intel Wireless 7260) + 5G + AP mode
Message-id: <987F8999-2BD8-467F-B687-853B58777558@me.com> (sfid-20141110_223130_421473_B399EF72)
Date: Mon, 10 Nov 2014 22:31:04 +0100
To: linux-wireless <linux-wireless@vger.kernel.org>
MIME-version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> >> I’m trying to get the 7260 to act as an AP on the 5G band. Unfortunately it seems to be impossible due to the „no IR“ reg domain restriction done by the Intel firmware internally (this is what I’ve googled so far..).
>> >>
>> >> Could someone explain to me the technical background of this. As far as I understood the regulation if DFS and TPC are used, most of the 5G channels are allowed. Did I miss something? What’s the point of restricting the IR then?
> >
> > This is not true world wide. With the devices currently available, you
> > can't have IR in 5GHz.
> >

Even so I don't want to teach you wrong, a quick look at wikipedia reveals a slightly different view on this: 
https://en.wikipedia.org/wiki/List_of_WLAN_channels#5.C2.A0GHz_.28802.11a.2Fh.2Fj.2Fn.2Fac.29.5B17.5D

I mean that's exactly what's the linux kernel reg domain stuff ( http://wireless.kernel.org/en/developers/Regulatory/processing_rules ) is meant to manage, isn't it?


> 
> Let me clarify, with *Intel* devices currently available, you will not
> be able to have IR in 5GHz.
 
That's the reason I wrote the mail in the first place. I wasn't able to use AP mode at 5G. Wich I found out by myself and didn't read somewhere e.g. at http://wireless.kernel.org/en/users/Drivers/iwlwifi . If it's that clear and obvious, why not state it there? I would have saved me 50 Euros and some hours...

Just a feeling, but I guess asking something like "Why?" wouldn't help me in understanding, right? This is just some marketing decision at Intel (don't support 5G AP mode in consumer WiFi cards) developers have to follow.


> >>
> >> And finally: Is there a way to get it work? Some other PCI-E chip? ath10k?
 
Does anyone have a working setup for 5G AP mode with linux using a (m)PCI(-e) card? Or are there only SoCs available for this job? 

Thanks,
Efill