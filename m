Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58935 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab0JERiK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 13:38:10 -0400
Message-ID: <4CAB627F.8020804@candelatech.com>
Date: Tue, 05 Oct 2010 10:38:07 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
References: <4CAB59B2.5050106@candelatech.com> <AANLkTikhGCTS8kJgpDzjudyBTk-rkyXY33UO7kB0+Cc-@mail.gmail.com> <4CAB5F3D.9060201@candelatech.com> <AANLkTimV3GrwU+9PPtirT4sCzveLY2egr3PRQhfDBET1@mail.gmail.com>
In-Reply-To: <AANLkTimV3GrwU+9PPtirT4sCzveLY2egr3PRQhfDBET1@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/05/2010 10:36 AM, Luis R. Rodriguez wrote:
> On Tue, Oct 5, 2010 at 10:24 AM, Ben Greear<greearb@candelatech.com>  wrote:
>> On 10/05/2010 10:16 AM, Luis R. Rodriguez wrote:
>>>
>>> On Tue, Oct 5, 2010 at 10:00 AM, Ben Greear<greearb@candelatech.com>
>>>   wrote:
>>>>
>>>> I started seeing this very soon after creating interfaces.
>>>
>>> Can you be more specific how one can reproduce?
>>
>> Enable SLUB debugging, DEBUG_PAGEALLOC (Debug page memory allocations),
>> lockdep, pre-empt.
>
> OK I just enabled PAGE_ALLOC thingy, it wasn't enabled on my kernel.
>
>> Please try creating a bunch of stations on one ath9k phy,
>
> How many?

130 is a nice round number :)

I'll try with a smaller number and see if I can hit it.

Thanks,
Ben

>
>    Luis


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

