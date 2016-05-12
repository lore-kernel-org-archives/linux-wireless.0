Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35265 "EHLO
	mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086AbcELQTq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2016 12:19:46 -0400
Received: by mail-lf0-f68.google.com with SMTP id u64so8285201lff.2
        for <linux-wireless@vger.kernel.org>; Thu, 12 May 2016 09:19:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <874ma3eqh0.fsf@kamboji.qca.qualcomm.com>
References: <1462995634-24602-1-git-send-email-jjmeijer88@gmail.com>
 <57339C5B.1050307@broadcom.com> <874ma3eqh0.fsf@kamboji.qca.qualcomm.com>
From: Jaap Jan Meijer <jjmeijer88@gmail.com>
Date: Thu, 12 May 2016 18:19:19 +0200
Message-ID: <CAA+NYvRvVXF0-x9s8qDBaL0_Weuin5+CAsZXZu5Wt+_M1FGMWw@mail.gmail.com> (sfid-20160512_182005_833867_1D6FEF0C)
Subject: Re: [PATCH] brcmfmac: add fallback for devices that do not report
 per-chain values
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2016-05-11 22:55 GMT+02:00 Arend van Spriel <arend.vanspriel@broadcom.com>:
> However, this patch changes more. I did not get back on your question
> regarding beacon period and dtim. Sorry for that as it means this patch
> still need rework. Those values are obtained differently and filled in
> by the function brcmf_fill_bss_param() (called in line 2530). When you
> do that make sure the subject prefix is 'PATCH v2' iso 'PATCH' (using
> git format-patch option --subject-prefix=..) and add a changelog after
> your signed-off line as shown below:
>
> Signed-off-by: Jaap Jan Meijer <jjmeijer88@gmail.com>
> ---
> change log:
>  v2:
>         - bla...
> ---
>  .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 42
> ++++++++++++++++++++++
>
> Don't get discouraged :-D Nederlander?

I won't but I hope you won't either and yes, what gave it away? ;)


2016-05-12 8:32 GMT+02:00 Kalle Valo <kvalo@codeaurora.org>:
>
> This fixed a regression, right? So then a Fixes line would be nice:
>
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/SubmittingPatches#n171
>
> --
> Kalle Valo

Thank you for the feedback guys, I will send a new patch shortly.
