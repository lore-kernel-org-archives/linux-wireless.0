Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35014 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751718AbdF3LEU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Jun 2017 07:04:20 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: iwlwifi-next 2017-06-30
References: <1498817319.22048.161.camel@coelho.fi>
Date: Fri, 30 Jun 2017 14:04:13 +0300
In-Reply-To: <1498817319.22048.161.camel@coelho.fi> (Luca Coelho's message of
        "Fri, 30 Jun 2017 13:08:39 +0300")
Message-ID: <874luxn3de.fsf@kamboji.qca.qualcomm.com> (sfid-20170630_130521_521574_29DE58C8)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Hi Kalle,
>
> Here's my final pull-request intended for v4.13.=C2=A0 Again, this pull-
> request includes the last two patchsets I sent out.=C2=A0 Most importantl=
y,
> it contains critical fixes and FW API changes to support the upcoming FW
> that we will release publicly for the 9000 HW family.=C2=A0 More=C2=A0det=
ails in
> the tag description.
>
> I have sent this out before, and kbuildbot reported success.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit fdcbe65d618af080ee23229f0137ffd37f2de3=
6b:
>
>   Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo=
/ath.git (2017-06-28 22:10:48 +0300)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git =
tags/iwlwifi-next-for-kalle-2017-06-30
>
> for you to fetch changes up to ba320dd61ec91bbe98730f3407a486facc174d63:
>
>   iwlwifi: bump MAX API for 8000/9000/A000 to 33 (2017-06-29 21:09:58 +03=
00)
>
> ----------------------------------------------------------------
> Final set of patches for 4.13
>
> * Some important fixes for 9000 HW;
> * FW API changes for the upcoming -30 ucode release;
> * A few new PCI IDs for 9000 series;
> * Reorganization of common files;
> * Some more fixes and improvements here and there
> * Initialization and other important fixes for 9000 series;
> * Support for version 30 of the FW API for 8000 and 9000 series;
>
> ----------------------------------------------------------------

Pulled, thanks.

Let's see if I can squeeze these into 4.13 still. But in the future
please submit patches early, for various reasons (extra work, higher
chance of regressions etc) I really dislike having last minute patches
for new features.

--=20
Kalle Valo
