Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.freestuffjunction.co.uk ([109.169.51.71]:28215 "EHLO
	mail.freestuffjunction.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752510Ab2KFUi6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 15:38:58 -0500
Message-ID: <50997556.7030909@ehuk.net> (sfid-20121106_213910_608570_9E3F6AD6)
Date: Tue, 06 Nov 2012 20:38:46 +0000
From: Eddie Chapman <eddie@ehuk.net>
Reply-To: eddie@ehuk.net
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: stable@vger.kernel.org, florian@reitmeir.org,
	linux-wireless@vger.kernel.org, j@w1.fi
Subject: Re: Linux 3.6.5
References: <20121031173811.GA12970@kroah.com> <509575F4.5020109@ehuk.net>      <20121105081757.GA3730@kroah.com> <50979D38.6010002@ehuk.net>      (sfid-20121105_121423_464154_72561532) <1352116868.9466.2.camel@jlt4.sipsolutions.net>     <509838F4.4010301@ehuk.net>    <1352188621.9440.4.camel@jlt4.sipsolutions.net>   <50992E0E.3040606@ehuk.net>   <1352217244.9440.16.camel@jlt4.sipsolutions.net>   <50995E25.6080601@ehuk.net>  <1352229634.8814.8.camel@jlt4.sipsolutions.net> <5099669E.2040301@ehuk.net> <1352233894.8814.10.camel@jlt4.sipsolutions.net>
In-Reply-To: <1352233894.8814.10.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/11/12 20:31, Johannes Berg wrote:
> On Tue, 2012-11-06 at 19:35 +0000, Eddie Chapman wrote:
>
>>> Right, we're still looking at that. It seems that it's not an ideal
>>> solution, the regulatory change I proposed is probably better. Could you
>>> check if it helps as well? That is, remove this patch, and apply this
>>> one: http://p.sipsolutions.net/8877cbe3440d94b1.txt
>>
>> OK, so I've removed 0129f39c7d882289.txt, applied 8877cbe3440d94b1.txt,
>> and I've kept 3a40414f826a8f1096d9b94c4a53ef91b25ba28d applied.
>>
>> Rebooted, and happy to report throughput is still good, so
>> 8877cbe3440d94b1.txt also "fixes" it for me.
>
> Great, thanks. I'm not really sure which one to apply, and if we apply
> the 8877 one we'll also want to update the reg db (that you aren't
> using). A lot of people are in Barcelona right now though, so that might
> be a week or so until we can close this.

No hurry at all from my point of view.

> Thanks for all the testing!

Not at all, it's a pleasure to be able to contribute in some tiny way to 
kernel development.
