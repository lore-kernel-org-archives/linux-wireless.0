Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:54503 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab2GSO7r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2012 10:59:47 -0400
Received: by gglu4 with SMTP id u4so2850952ggl.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jul 2012 07:59:46 -0700 (PDT)
Message-ID: <500820DF.1030008@lwfinger.net> (sfid-20120719_165951_284904_1ED31395)
Date: Thu, 19 Jul 2012 09:59:43 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Andreas_Br=E4u?= <ab@andi95.de>
CC: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	Bastian Bittorf <bittorf@bluebottle.com>,
	openwrt-devel@lists.openwrt.org, linux-wireless@vger.kernel.org,
	feint@lists.subsignal.org
Subject: Re: WRT54g / b43 / mac802.11 BREAKTHROUGH
References: <1342612598.5006a476022c6@mail.bluebottle.com> <CA+XFjiqGXCdMYOnQz95biGYdR65x8dEAZzWnyAoWovEJ1tFQrw@mail.gmail.com> <982FBF04-5969-436D-9D3A-A6388C077667@andi95.de>
In-Reply-To: <982FBF04-5969-436D-9D3A-A6388C077667@andi95.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/19/2012 02:18 AM, Andreas Bräu wrote:
>>>
>>> 1) why does a band change (can be seen through minstrel) is a problem?
>>
>> Because IIRC b43 doesn't support anything other than 2.4GHz at all.
>
> It's not a change between 2.4 and 5 GHz.
> Wifi stops working if the bitrate changes between 11b (1, 2, 5.5, 11) and 11g (6, 9, 12, 18, 24, 36, 48, 54) rates
>
> So if we tell the system to only use 11g rates, wifi doesn't stop.

Andi,

Rates for 11g include 1, 2, 5.5, and 11, as well as 6, 9, ... What you really 
want to say is that it fails when it switches between CCCK and OFDM rates.

What chip is in your WRT54G?

Larry


