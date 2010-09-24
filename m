Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:52884 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab0IXODq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 10:03:46 -0400
Message-ID: <4C9CAFBC.3010702@candelatech.com>
Date: Fri, 24 Sep 2010 07:03:40 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michael Griepentrog <griepent@cs.wisc.edu>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Detect if phy is a/b/g/n?
References: <4C9BA6ED.8080304@candelatech.com> <AANLkTinY7y7Gf8K518293mdzXh5=42gQ64eUJjJFSaBw@mail.gmail.com> <4C9BC28E.7010105@candelatech.com> <AANLkTinHY5LfzcQNvbVr6kY87Bjhy0TMYB8uU=k0ReZU@mail.gmail.com>
In-Reply-To: <AANLkTinHY5LfzcQNvbVr6kY87Bjhy0TMYB8uU=k0ReZU@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/23/2010 03:22 PM, Michael Griepentrog wrote:
> There should also be a "HT TX/RX MCS rate indexes supported:" for n rates.

That is unique, so I can use that.

Next time someone is hacking on this, though, it would be nice for
a simple print-out of the various a/b/g/n modes supported!

Thanks,
Ben

>
> Mike
>
> On Thu, Sep 23, 2010 at 4:11 PM, Ben Greear<greearb@candelatech.com>  wrote:
>> On 09/23/2010 01:35 PM, Luis R. Rodriguez wrote:
>>>
>>> On Thu, Sep 23, 2010 at 12:13 PM, Ben Greear<greearb@candelatech.com>
>>>   wrote:
>>>>
>>>> Is there a way to determine what a/b/g/n modes a particular phy
>>>> supports?  I tried 'iw phy', but I didn't see anything
>>>> obvious.
>>>
>>> 'iw list' Rates?
>>
>> Both a/b/g (ath5k) and /n (ath9k) show top speed of 54Mbps
>> on my systems.
>>
>> Ben
>>
>> --
>> Ben Greear<greearb@candelatech.com>
>> Candela Technologies Inc  http://www.candelatech.com
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
