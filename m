Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51794 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965823AbeEXNgP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 May 2018 09:36:15 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Tony Lindgren <tony@atomide.com>
Cc: "Reizer\, Eyal" <eyalr@ti.com>, Eyal Reizer <eyalreizer@gmail.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH] wlcore: use generic runtime pm calls for wowlan elp configuration
References: <1527146337-17562-1-git-send-email-eyalr@ti.com>
        <87fu2hiilx.fsf@codeaurora.org>
        <06f0b1b5243a4ab7befad7b9109bf5a5@ti.com>
        <20180524132132.GZ98604@atomide.com>
Date: Thu, 24 May 2018 16:36:09 +0300
In-Reply-To: <20180524132132.GZ98604@atomide.com> (Tony Lindgren's message of
        "Thu, 24 May 2018 06:21:32 -0700")
Message-ID: <87efi1b2gm.fsf@kamboji.qca.qualcomm.com> (sfid-20180524_153712_598048_5F87F94B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tony Lindgren <tony@atomide.com> writes:

> * Reizer, Eyal <eyalr@ti.com> [180524 08:20]:
>> > 
>> > > With runtime PM enabled, we can now use generic calls to
>> > > pm_generic_runtime_suspend and pm_generic_runtime_resume for
>> > enabling elp
>> > > during suspend when wowlan is enabled and waking the chip from elp
>> > > on resume.
>> > > remove the custom API that was used to ensure that the command
>> > > that is used to allow ELP during suspend is completed before the system
>> > > suspend.
>> > >
>> > > Signed-off-by: Eyal Reizer <eyalr@ti.com>
>> > > ---
>> > > Dependent on the Runtime PM support for wlcore patch set that was
>> > submitted
>> > > by Tony Lindgren <tony@atomide.com>
>> > 
>> > Ok, I'll drop this from my queue. Please resubmit once Tony's patches
>> > are ready to apply (or Tony can include this patch in his patchset).
>> > 
>> > BTW, for me it would be a lot easier if you could mark patches like this
>> > as RFT (Request For Test) or RFC (Request For Comments). That way I can
>> > automatically drop the patch without sending any emails.
>
> Sorry for the noise, what seemed like a trivial change to use generic
> runtime PM exposed few unexpected issues :) I'll do one more revision
> of all the patches with RFT. Then when we are happy with that series,
> I'll do one more patch to enable runtime PM autosuspend support to
> avoid enabling and disabing the hardware constantly. And then after
> that we should have the patches finally ready for merging.

Sounds good to me, kiitos :)

-- 
Kalle Valo
