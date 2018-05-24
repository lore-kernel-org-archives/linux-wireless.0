Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44966 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935598AbeEXIFg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 May 2018 04:05:36 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Eyal Reizer <eyalreizer@gmail.com>
Cc: tony@atomide.com, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org, Eyal Reizer <eyalr@ti.com>
Subject: Re: [PATCH] wlcore: use generic runtime pm calls for wowlan elp configuration
References: <1527146337-17562-1-git-send-email-eyalr@ti.com>
Date: Thu, 24 May 2018 11:05:30 +0300
In-Reply-To: <1527146337-17562-1-git-send-email-eyalr@ti.com> (Eyal Reizer's
        message of "Thu, 24 May 2018 10:18:57 +0300")
Message-ID: <87fu2hiilx.fsf@codeaurora.org> (sfid-20180524_100543_458111_FA5844D8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eyal Reizer <eyalreizer@gmail.com> writes:

> With runtime PM enabled, we can now use generic calls to
> pm_generic_runtime_suspend and pm_generic_runtime_resume for enabling elp
> during suspend when wowlan is enabled and waking the chip from elp
> on resume.
> remove the custom API that was used to ensure that the command
> that is used to allow ELP during suspend is completed before the system
> suspend.
>
> Signed-off-by: Eyal Reizer <eyalr@ti.com>
> ---
> Dependent on the Runtime PM support for wlcore patch set that was submitted 
> by Tony Lindgren <tony@atomide.com>

Ok, I'll drop this from my queue. Please resubmit once Tony's patches
are ready to apply (or Tony can include this patch in his patchset).

BTW, for me it would be a lot easier if you could mark patches like this
as RFT (Request For Test) or RFC (Request For Comments). That way I can
automatically drop the patch without sending any emails.

-- 
Kalle Valo
