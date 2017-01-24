Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44178 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750795AbdAXMaW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jan 2017 07:30:22 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: iwlwifi 2017-01-23
References: <1485204642.2774.60.camel@coelho.fi>
Date: Tue, 24 Jan 2017 14:30:17 +0200
In-Reply-To: <1485204642.2774.60.camel@coelho.fi> (Luca Coelho's message of
        "Mon, 23 Jan 2017 22:50:42 +0200")
Message-ID: <87inp48wti.fsf@kamboji.qca.qualcomm.com> (sfid-20170124_133026_017322_0358122A)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Hi Kalle,
>
> After a long time (too long time, I admit), here comes a pull request
> with two fixes intended for v4.10.  Nothing major, just two small fixes
> that were pending in our internal trees.  I have some more, but I'm
> keeping this small for the -rc series.  More details in the tag
> description.
>
> I have sent this out before and kbuildbot didn't find any issues.
>
> Cheers,
> Luca.
>
>
>
> The following changes since commit 92549cdc288f47f3a98cf80ac5890c91f5876a=
06:
>
> =C2=A0 iwlwifi: fix kernel crash when unregistering thermal zone
> (2017-01-21 14:58:37 +0200)
>
> are available in the git repository at:
>
> =C2=A0
> git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git
> tags/iwlwifi-for-kalle-2017-01-23
>
> for you to fetch changes up to 03c902bff524e0cf664737a33f2365f7837040bf:
>
> =C2=A0 iwlwifi: mvm: avoid crash on restart w/o reserved queues (2017-01-=
23 12:55:32 +0200)
>
> ----------------------------------------------------------------
> * Remove an extra hyphen from a string that was preventing the firmware t=
o load
> * Avoid a crash when the firmware is restarted in certain scenarios with =
DQA
>
> ----------------------------------------------------------------

Pulled, thanks.

--=20
Kalle Valo
