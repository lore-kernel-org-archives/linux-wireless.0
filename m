Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45747 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab0JEVmk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 17:42:40 -0400
Message-ID: <4CAB9BCD.7010501@candelatech.com>
Date: Tue, 05 Oct 2010 14:42:37 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Ming Lei <tom.leiming@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: lockdep warning in ieee80211 rx path
References: <AANLkTin5KfmQLYxLWdhTcO-AM0t83dVq=LFCG0UGysaw@mail.gmail.com> <201010042000.44518.chunkeey@googlemail.com> <4CAA17FA.3080403@candelatech.com> <201010042036.12542.chunkeey@googlemail.com>
In-Reply-To: <201010042036.12542.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/04/2010 11:36 AM, Christian Lamparter wrote:
> On Monday 04 October 2010 20:07:54 Ben Greear wrote:
>> On 10/04/2010 11:00 AM, Christian Lamparter wrote:
>>> On Monday 04 October 2010 19:52:12 Ben Greear wrote:
>>>> On 09/14/2010 01:51 PM, Christian Lamparter wrote:
>>>>> On Sunday 05 September 2010 11:32:26 Ming Lei wrote:
>>>>>> Seems the warning does not affect use of wireless,  false positive?
>>>>>
>>>>> No, it's a bug... but please read&    test the attached patch.
>>>>
>>>> This is not yet in wireless-testing.  Should it be?
>>> have you heard anything from Ming Lei about this subject?
>>> Or have you reproduced the bug too?
>>
>> See my post about   inconsistent {IN-SOFTIRQ-W} ->  {SOFTIRQ-ON-W}.
>>
>> I'm not sure it's the same bug, but it would appear similar at least.
> At first glance, your trace looks unrelated to Ming Lei's issue.
> But we won't know for sure, unless you have a reliable way to
> reproduce the exact circumstances.
>
>> If your patch is probably good, I can go ahead and apply it.
>> We can at least test that it doesn't obviously make things worse.
> Ok, if the patch doesn't make things worse than they are, I can
> risk another attempt.

We've been running your patch for a few days, and it hasn't caused
any additional problems as far as I can tell.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

