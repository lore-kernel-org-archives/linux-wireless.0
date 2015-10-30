Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34570 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758258AbbJ3Ftg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 01:49:36 -0400
Received: by padhk11 with SMTP id hk11so63647832pad.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2015 22:49:36 -0700 (PDT)
Date: Fri, 30 Oct 2015 05:49:25 +0000
From: yfw <fengwei.yin@linaro.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Nicolas Dechesne <nicolas.dechesne@linaro.org>,
	wcn36xx@lists.infradead.org, Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org,
	Bjorn Andersson <bjorn.andersson@sonymobile.com>,
	k.eugene.e@gmail.com
Subject: Re: [PATCH] wcn36xx: Remove warning message when dev is NULL for
 arm64 dma_alloc.
Message-ID: <20151030054923.GA11592@gmail.com> (sfid-20151030_064941_294868_3CAF1FE4)
References: <1445826982-4023-1-git-send-email-fengwei.yin@linaro.org>
 <878u6lo34e.fsf@kamboji.qca.qualcomm.com>
 <5632AC81.6090905@linaro.org>
 <5632ACFA.1090709@linaro.org>
 <CAP71Wjwc5HcfG6UKy-XFwtmB1ZxgJvM0FWf5NT3G6DjNOKwDqA@mail.gmail.com>
 <874mh9ne7x.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <874mh9ne7x.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 30, 2015 at 06:59:46AM +0200, Kalle Valo wrote:
> Nicolas Dechesne <nicolas.dechesne@linaro.org> writes:
> 
> > On Fri, Oct 30, 2015 at 12:34 AM, fengwei.yin <fengwei.yin@linaro.org> wrote:
> >>>>
> >>>>
> >>>> Please fix your name. I don't know why but your name in git statistics
> >>>> is now "yfw":
> >>>>
> >>>> yfw (1):
> >>>>        wcn36xx: Remove warning message when dev is NULL for arm64 dma_alloc.
> >>>>
> >>>> The right format for both From header and Signed-off-by line is:
> >>>>
> >>>> First Lastname <username@example.com>
> >>>>
> >>>
> >>> It looks like everything is fine in my side. Could you please check your
> >>> .mailmap whether the email was mapped to "yfw"?
> >>
> >>                    ~~~~~~~~~~ typo fix: "my email address"
> >
> > fwiw.. I applied the original patch from the list locally, and I don't
> > see this issue after git am <file>:
> >
> > $ git shortlog -1
> > Yin, Fengwei (1):
> >       wcn36xx: Remove warning message when dev is NULL for arm64 dma_alloc.
> 
> Ah, I think it's coming from patchwork:
> 
> "Submitter	yfw"
> 
> https://patchwork.kernel.org/patch/7484791/
> 
> Fengwei, please fix your name in patchwork. It should be easy to do.
Kalle, any clue about how to change the name in patchwork? I can't find
how on the patchwork website.

> 
> Anyway, my original comment still stands. The correct format for name
> is:
> 
>         Random J Developer <random@developer.example.org>
> 
> NOT:
> 
>         Developer, Random J <random@developer.example.org>
> 
> See SubmittingPatches.
Will update the patch. Thanks.

Regards
Yin, Fengwei

> 
> -- 
> Kalle Valo
