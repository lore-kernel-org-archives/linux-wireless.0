Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:10845 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477AbZBDXTX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 18:19:23 -0500
Received: by yw-out-2324.google.com with SMTP id 9so1049884ywe.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2009 15:19:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200902050010.27428.rossi.f@inwind.it>
References: <200902050010.27428.rossi.f@inwind.it>
Date: Thu, 5 Feb 2009 01:19:22 +0200
Message-ID: <40f31dec0902041519t5dcab35n19e6a0ec1642eaa5@mail.gmail.com> (sfid-20090205_001940_041674_63728A92)
Subject: Re: ath5k: problems with wireless network data transfer
From: Nick Kossifidis <mickflemm@gmail.com>
To: Fabio Rossi <rossi.f@inwind.it>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/2/5 Fabio Rossi <rossi.f@inwind.it>:
> I'm using the lastest wireless-testing for connecting to my access point using
> the ath5k driver. There are no problems in associating to the AP.
>
> I have a lot of problems with the connection in the sense that I observe
> frequently no data transfer between the station and the AP (and so Internet).
> During this network inactivity I can't ping the router or the route command
> is stuck for many seconds. During these periods of time (when I can't use the
> network) the station is always associated to the AP.
>
> Basically the problem arises when I observe a stall in a (previously
> initiated) data transfer or I can't open web pages. I'm sure that the
> wireless network is running correctly because I use at the same time a
> second PC working with the p54pci driver. Moreover there are no problems if I
> connect to the router via ethernet cable.
>
> For example, if I ping (during the same period of time) the router from the
> two PCs, I get the following results:
>
> (ath5k based PC)
> 526 packets transmitted, 366 received, 30% packet loss, time 526508ms
> rtt min/avg/max/mdev = 0.896/3.963/223.934/12.986 ms
>
> (p54pci based PC)
> 525 packets transmitted, 524 received, 0% packet loss, time 526127ms
> rtt min/avg/max/mdev = 1.145/8.392/408.565/29.224 ms
>
> Any idea about the problem or how I can debug this situation?
>
> Regards,
> Fabio

Can you please post a dmesg output when ath5k loads ?


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
