Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42885 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758538AbbJ3GCQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 02:02:16 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: yfw <fengwei.yin@linaro.org>
Cc: Nicolas Dechesne <nicolas.dechesne@linaro.org>,
	wcn36xx@lists.infradead.org, Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org,
	Bjorn Andersson <bjorn.andersson@sonymobile.com>,
	k.eugene.e@gmail.com
Subject: Re: [PATCH] wcn36xx: Remove warning message when dev is NULL for arm64 dma_alloc.
References: <1445826982-4023-1-git-send-email-fengwei.yin@linaro.org>
	<878u6lo34e.fsf@kamboji.qca.qualcomm.com>
	<5632AC81.6090905@linaro.org> <5632ACFA.1090709@linaro.org>
	<CAP71Wjwc5HcfG6UKy-XFwtmB1ZxgJvM0FWf5NT3G6DjNOKwDqA@mail.gmail.com>
	<874mh9ne7x.fsf@kamboji.qca.qualcomm.com>
	<20151030054923.GA11592@gmail.com>
Date: Fri, 30 Oct 2015 08:02:08 +0200
In-Reply-To: <20151030054923.GA11592@gmail.com> (yfw's message of "Fri, 30 Oct
	2015 05:49:25 +0000")
Message-ID: <87ziz0nbbz.fsf@kamboji.qca.qualcomm.com> (sfid-20151030_070225_116597_C185BE5C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

yfw <fengwei.yin@linaro.org> writes:

> On Fri, Oct 30, 2015 at 06:59:46AM +0200, Kalle Valo wrote:
>> Nicolas Dechesne <nicolas.dechesne@linaro.org> writes:
>> 
>> > fwiw.. I applied the original patch from the list locally, and I don't
>> > see this issue after git am <file>:
>> >
>> > $ git shortlog -1
>> > Yin, Fengwei (1):
>> >       wcn36xx: Remove warning message when dev is NULL for arm64 dma_alloc.
>> 
>> Ah, I think it's coming from patchwork:
>> 
>> "Submitter	yfw"
>> 
>> https://patchwork.kernel.org/patch/7484791/
>> 
>> Fengwei, please fix your name in patchwork. It should be easy to do.
>
> Kalle, any clue about how to change the name in patchwork? I can't find
> how on the patchwork website.

Not sure. I think first need to register with the same email address:

https://patchwork.kernel.org/register/

>> Anyway, my original comment still stands. The correct format for name
>> is:
>> 
>>         Random J Developer <random@developer.example.org>
>> 
>> NOT:
>> 
>>         Developer, Random J <random@developer.example.org>
>> 
>> See SubmittingPatches.
>
> Will update the patch. Thanks.

It's too late for this patch as I already applied it.

-- 
Kalle Valo
