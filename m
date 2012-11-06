Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.freestuffjunction.co.uk ([109.169.51.71]:50284 "EHLO
	mail.freestuffjunction.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866Ab2KFRHa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 12:07:30 -0500
Message-ID: <509943C1.6080300@ehuk.net> (sfid-20121106_180744_429142_F72E47B6)
Date: Tue, 06 Nov 2012 17:07:13 +0000
From: Eddie Chapman <eddie@ehuk.net>
Reply-To: Eddie Chapman <eddie@ehuk.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: stable@vger.kernel.org, florian@reitmeir.org,
	linux-wireless@vger.kernel.org, j@w1.fi
Subject: Re: Linux 3.6.5
References: <20121031173811.GA12970@kroah.com> <509575F4.5020109@ehuk.net>  <20121105081757.GA3730@kroah.com> <50979D38.6010002@ehuk.net>  (sfid-20121105_121423_464154_72561532) <1352116868.9466.2.camel@jlt4.sipsolutions.net>  <509838F4.4010301@ehuk.net> <1352188621.9440.4.camel@jlt4.sipsolutions.net>  <50992E0E.3040606@ehuk.net>  <1352217244.9440.16.camel@jlt4.sipsolutions.net>  (sfid-20121106_165343_414402_7F00AE58) <1352219976.9440.18.camel@jlt4.sipsolutions.net>  <50993FC2.7040100@ehuk.net> <1352220942.8814.0.camel@jlt4.sipsolutions.net>  (sfid-20121106_175519_403098_E3B30E7C) <1352221044.8814.1.camel@jlt4.sipsolutions.net>
In-Reply-To: <1352221044.8814.1.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/11/12 16:57, Johannes Berg wrote:
> On Tue, 2012-11-06 at 17:55 +0100, Johannes Berg wrote:
>> Hi Eddie,
>>
>>> In the AP's dmesg output which I included in my other message, I see this:
>>>
>>> <6>[    9.300000] cfg80211: Regulatory domain changed to country: GB
>>>
>>> So it seems the AP knows where it is, but is it not transmitting that to
>>> the client?
>>
>> Evidently, I don't see a country IE in the iw scan output you posted.
>
> Then again, what version of iw do you have? This only applies if it's
> version 0.9.20 or higher.
>
> johannes

I don't see a country specified in the output I sent you either. We're 
talking about iw scan on the client right, not the AP?

Over on the AP, I just looked in the web interface, and there is a drop 
down box for "Regulatory Domain", and I have it set to "United Kingdom".

as for iw version on the client it says:

nc6400 ~ # iw --version
iw version 3.3

You mentioned crda, it seems gentoo has it, I can install it on the 
client if you think it will help in figuring this out?

nc6400 ~ # emerge --search crda
Searching...
[ Results for search key : crda ]
[ Applications found : 1 ]

*  net-wireless/crda
       Latest version available: 1.1.2-r3
       Latest version installed: [ Not Installed ]
       Size of files: 21 kB
       Homepage:      http://wireless.kernel.org/en/developers/Regulatory
       Description:   Central Regulatory Domain Agent for wireless networks.
       License:       as-is
