Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:36617 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772Ab1C0Pi1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Mar 2011 11:38:27 -0400
Message-ID: <4D8F5A37.9070306@justmail.de>
Date: Sun, 27 Mar 2011 17:39:35 +0200
From: =?ISO-8859-1?Q?Klaus_M=FCller?= <kmueller@justmail.de>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Richard_Sch=FCtz?= <r.schtz@t-online.de>,
	linux-wireless@vger.kernel.org
Subject: Re: broken ath9k-driver - problems with creating new TCP-connections.
 Bad performance
References: <4D8F28C1.4060402@justmail.de> <4D8F2F3E.9030802@openwrt.org> <4D8F4B9F.9010809@justmail.de> <4D8F50A6.70508@t-online.de>
In-Reply-To: <4D8F50A6.70508@t-online.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Richard Schütz wrote:
>> If the AP is set to HT20, this driver doesn't use IEEE 802.11n any more,
>> or, to say it more specific: the selected bit rate is max. 64 Mb/s and
>> the performance is even worse.
> 
> Of course it uses 802.11n, but only with 20 MHz channel width, so the
> data rate is lower than with 40 Mhz channel width. The highest rate of
> 802.11g is 54 Mbit/s anyway.

I know - but there isn't any difference between g and n with 20 MHz
channel in real performance. That's why I wrote the driver wouldn't use
n any more. But this wasn't correct with respect of the technical view.

>> I'm wondering at all, why the ath9k driver doesn't switch to 300 Mb/s:
>> the rt3572sta-driver doesn't have any problem with both settings.
> 
> Your AR9285 only supports up to 150 Mbit/s.

Now it's clear, why 150 Mbit/s is the maximum.


Klaus
