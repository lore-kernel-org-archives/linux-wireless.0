Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:33882 "EHLO
	mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173AbbJ2XmA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 19:42:00 -0400
Received: by qkcn129 with SMTP id n129so24398258qkc.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2015 16:41:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5632ACFA.1090709@linaro.org>
References: <1445826982-4023-1-git-send-email-fengwei.yin@linaro.org>
 <878u6lo34e.fsf@kamboji.qca.qualcomm.com> <5632AC81.6090905@linaro.org> <5632ACFA.1090709@linaro.org>
From: Nicolas Dechesne <nicolas.dechesne@linaro.org>
Date: Fri, 30 Oct 2015 00:41:40 +0100
Message-ID: <CAP71Wjwc5HcfG6UKy-XFwtmB1ZxgJvM0FWf5NT3G6DjNOKwDqA@mail.gmail.com> (sfid-20151030_004204_654336_E8CEB4DD)
Subject: Re: [PATCH] wcn36xx: Remove warning message when dev is NULL for
 arm64 dma_alloc.
To: "fengwei.yin" <fengwei.yin@linaro.org>
Cc: Kalle Valo <kvalo@codeaurora.org>, wcn36xx@lists.infradead.org,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org,
	Bjorn Andersson <bjorn.andersson@sonymobile.com>,
	k.eugene.e@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 30, 2015 at 12:34 AM, fengwei.yin <fengwei.yin@linaro.org> wrote:
>>>
>>>
>>> Please fix your name. I don't know why but your name in git statistics
>>> is now "yfw":
>>>
>>> yfw (1):
>>>        wcn36xx: Remove warning message when dev is NULL for arm64 dma_alloc.
>>>
>>> The right format for both From header and Signed-off-by line is:
>>>
>>> First Lastname <username@example.com>
>>>
>>
>> It looks like everything is fine in my side. Could you please check your
>> .mailmap whether the email was mapped to "yfw"?
>
>                    ~~~~~~~~~~ typo fix: "my email address"

fwiw.. I applied the original patch from the list locally, and I don't
see this issue after git am <file>:

$ git shortlog -1
Yin, Fengwei (1):
      wcn36xx: Remove warning message when dev is NULL for arm64 dma_alloc.




fwiw
