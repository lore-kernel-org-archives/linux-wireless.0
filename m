Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57732 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751632AbdH3QTt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 12:19:49 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com
Subject: Re: pull-request: iwlwifi-next 2017-08-30
References: <1504085929.31031.8.camel@coelho.fi>
Date: Wed, 30 Aug 2017 19:19:43 +0300
In-Reply-To: <1504085929.31031.8.camel@coelho.fi> (Luca Coelho's message of
        "Wed, 30 Aug 2017 12:38:49 +0300")
Message-ID: <87ziahrpsw.fsf@kamboji.qca.qualcomm.com> (sfid-20170830_181953_074281_7E836ECE)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Here's my fourth and final pull-request intended for v4.14.=C2=A0 It cont=
ains
> just a couple of small fixes and a FW API number bump.=C2=A0=C2=A0More de=
tails in
> the tag description.
>
> I have fixed the subject of one of the patches for the typo you reported
> during review.
>
> I have sent this out before, and kbuildbot reported success.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit d081a16db80ef7a260fb178aa1199e01f74326=
25:
>
>   net: bcmgenet: Do not return from void function (2017-08-29 22:39:51 -0=
700)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git =
tags/iwlwifi-next-for-kalle-2017-08-30
>
> for you to fetch changes up to d7a5b3e9e42ee95190742fef0d617bbde4f74d80:
>
>   iwlwifi: mvm: bump API to 34 for 8000 and up (2017-08-30 12:30:56 +0300)
>
> ----------------------------------------------------------------
> Last set of iwlwifi patches for 4.14
>
> * Fix a queue hang problem due to 11w behavior
> * Fix a warning caused by a too long debug print
> * Bump API number to the latest version we support
>
> ----------------------------------------------------------------

Pulled, thanks.

--=20
Kalle Valo
