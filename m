Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54882 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022Ab0JDSHz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 14:07:55 -0400
Message-ID: <4CAA17FA.3080403@candelatech.com>
Date: Mon, 04 Oct 2010 11:07:54 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Ming Lei <tom.leiming@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: lockdep warning in ieee80211 rx path
References: <AANLkTin5KfmQLYxLWdhTcO-AM0t83dVq=LFCG0UGysaw@mail.gmail.com> <201009142251.53021.chunkeey@googlemail.com> <4CAA144C.7040906@candelatech.com> <201010042000.44518.chunkeey@googlemail.com>
In-Reply-To: <201010042000.44518.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/04/2010 11:00 AM, Christian Lamparter wrote:
> On Monday 04 October 2010 19:52:12 Ben Greear wrote:
>> On 09/14/2010 01:51 PM, Christian Lamparter wrote:
>>> On Sunday 05 September 2010 11:32:26 Ming Lei wrote:
>>>> Seems the warning does not affect use of wireless,  false positive?
>>>
>>> No, it's a bug... but please read&   test the attached patch.
>>
>> This is not yet in wireless-testing.  Should it be?
> have you heard anything from Ming Lei about this subject?
> Or have you reproduced the bug too?

See my post about   inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W}.

I'm not sure it's the same bug, but it would appear similar at least.

If your patch is probably good, I can go ahead and apply it.
We can at least test that it doesn't obviously make things worse.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

