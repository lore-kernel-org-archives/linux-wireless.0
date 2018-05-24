Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:10301 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965185AbeEXISU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 May 2018 04:18:20 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Eyal Reizer <eyalreizer@gmail.com>
CC: "tony@atomide.com" <tony@atomide.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH] wlcore: use generic runtime pm calls for
   wowlan elp configuration
Date: Thu, 24 May 2018 08:18:09 +0000
Message-ID: <06f0b1b5243a4ab7befad7b9109bf5a5@ti.com> (sfid-20180524_101944_241252_D838A7F0)
References: <1527146337-17562-1-git-send-email-eyalr@ti.com>
 <87fu2hiilx.fsf@codeaurora.org>
In-Reply-To: <87fu2hiilx.fsf@codeaurora.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>=20
> > With runtime PM enabled, we can now use generic calls to
> > pm_generic_runtime_suspend and pm_generic_runtime_resume for
> enabling elp
> > during suspend when wowlan is enabled and waking the chip from elp
> > on resume.
> > remove the custom API that was used to ensure that the command
> > that is used to allow ELP during suspend is completed before the system
> > suspend.
> >
> > Signed-off-by: Eyal Reizer <eyalr@ti.com>
> > ---
> > Dependent on the Runtime PM support for wlcore patch set that was
> submitted
> > by Tony Lindgren <tony@atomide.com>
>=20
> Ok, I'll drop this from my queue. Please resubmit once Tony's patches
> are ready to apply (or Tony can include this patch in his patchset).
>=20
> BTW, for me it would be a lot easier if you could mark patches like this
> as RFT (Request For Test) or RFC (Request For Comments). That way I can
> automatically drop the patch without sending any emails.
>=20

Understood. Thanks!

Best Regards,
Eyal
