Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:33288 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbcFJNQY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 09:16:24 -0400
Message-ID: <575ABDA2.9020609@candelatech.com> (sfid-20160610_151627_509320_FF31EFE1)
Date: Fri, 10 Jun 2016 06:16:18 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@nbd.name>, Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>,
	ath10k@lists.infradead.org, "A. Benz" <ash.benz@bk.ru>
Subject: Re: ath10k/QCA9980 - Issues introduced in wireless testing 2016-05
References: <ff65514a-47a3-2f32-658c-a2177401aa9a@bk.ru> <CA+BoTQmJ+JruxZ9WsG8Dnz=cwNY+e3Dy=g74-brS+0OE_5iu0Q@mail.gmail.com> <d836933e-ddbb-d10c-0715-6bce4396fd41@nbd.name> <877fdxfd2l.fsf@kamboji.qca.qualcomm.com> <575AB829.10101@candelatech.com> <f80db123-9b8a-289d-aed8-12531db13424@nbd.name>
In-Reply-To: <f80db123-9b8a-289d-aed8-12531db13424@nbd.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 06/10/2016 05:57 AM, Felix Fietkau wrote:
> On 2016-06-10 14:52, Ben Greear wrote:
>> This looks a lot like the problems I was having.
>>
>> Two of these 5 patches recently made it upstream (but may not be in LEDE yet),
>> but the other patches also were related to memory corruption.
>>
>> See my patches posted on 4/1/16:
>>
>> https://patchwork.kernel.org/project/ath10k/list/
>>
>> I don't know where the 5/5 patch ended up.
> I had already asked affected users to test with those patches (I have a
> commit that adds them in my staging tree), but it did not resolve the issue.

Ok, must be something else then.

If you can run on x86 under KASAN it may provide some clues..that is how I eventually
made progress on the issues I was seeing.  My rebase onto 3.7 has been slow and painful,
but I should be ready to start testing that sometime soon, maybe I can reproduce something
there.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
