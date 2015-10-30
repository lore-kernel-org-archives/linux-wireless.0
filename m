Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33355 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbbJ3Gl6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 02:41:58 -0400
Received: by padhy1 with SMTP id hy1so59022917pad.0
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2015 23:41:58 -0700 (PDT)
Subject: Re: [PATCH] wcn36xx: Remove warning message when dev is NULL for
 arm64 dma_alloc.
To: Kalle Valo <kvalo@codeaurora.org>
References: <1445826982-4023-1-git-send-email-fengwei.yin@linaro.org>
 <878u6lo34e.fsf@kamboji.qca.qualcomm.com> <5632AC81.6090905@linaro.org>
 <5632ACFA.1090709@linaro.org>
 <CAP71Wjwc5HcfG6UKy-XFwtmB1ZxgJvM0FWf5NT3G6DjNOKwDqA@mail.gmail.com>
 <874mh9ne7x.fsf@kamboji.qca.qualcomm.com> <20151030054923.GA11592@gmail.com>
 <87ziz0nbbz.fsf@kamboji.qca.qualcomm.com>
Cc: Nicolas Dechesne <nicolas.dechesne@linaro.org>,
	wcn36xx@lists.infradead.org, Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org,
	Bjorn Andersson <bjorn.andersson@sonymobile.com>,
	k.eugene.e@gmail.com
From: "fengwei.yin" <fengwei.yin@linaro.org>
Message-ID: <5633112F.7060406@linaro.org> (sfid-20151030_074201_953160_69C4503F)
Date: Fri, 30 Oct 2015 14:41:51 +0800
MIME-Version: 1.0
In-Reply-To: <87ziz0nbbz.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015/10/30 14:02, Kalle Valo wrote:
> yfw <fengwei.yin@linaro.org> writes:
>
>> On Fri, Oct 30, 2015 at 06:59:46AM +0200, Kalle Valo wrote:
>>> Nicolas Dechesne <nicolas.dechesne@linaro.org> writes:
>>>
>>>> fwiw.. I applied the original patch from the list locally, and I don't
>>>> see this issue after git am <file>:
>>>>
>>>> $ git shortlog -1
>>>> Yin, Fengwei (1):
>>>>        wcn36xx: Remove warning message when dev is NULL for arm64 dma_alloc.
>>>
>>> Ah, I think it's coming from patchwork:
>>>
>>> "Submitter	yfw"
>>>
>>> https://patchwork.kernel.org/patch/7484791/
>>>
>>> Fengwei, please fix your name in patchwork. It should be easy to do.
>>
>> Kalle, any clue about how to change the name in patchwork? I can't find
>> how on the patchwork website.
>
> Not sure. I think first need to register with the same email address:
>
> https://patchwork.kernel.org/register/

v2 was updated here:
https://patchwork.kernel.org/patch/7524381/

Regards
Yin, Fengwei

>
>>> Anyway, my original comment still stands. The correct format for name
>>> is:
>>>
>>>          Random J Developer <random@developer.example.org>
>>>
>>> NOT:
>>>
>>>          Developer, Random J <random@developer.example.org>
>>>
>>> See SubmittingPatches.
>>
>> Will update the patch. Thanks.
>
> It's too late for this patch as I already applied it.
>
