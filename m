Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42418 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751528AbdKTPrO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Nov 2017 10:47:14 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Subject: Re: pull-request: iwlwifi 2017-11-19
References: <1511175768.4011.261.camel@coelho.fi>
Date: Mon, 20 Nov 2017 17:47:09 +0200
In-Reply-To: <1511175768.4011.261.camel@coelho.fi> (Luca Coelho's message of
        "Mon, 20 Nov 2017 13:02:48 +0200")
Message-ID: <87bmjxdkaq.fsf@kamboji.qca.qualcomm.com> (sfid-20171120_164726_432000_3E0D98D6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Here is my first set of fixes for 4.15.  More details in the tag
> description.
>
> I have based it on wireless-drivers-next.git, because you didn't update
> wireless-drivers.git yet.  Let me know if you want me to rebase once
> you update.

No need to rebase, you did the right thing. And now I have fast forwarded
wireless-drivers to latest net tree.

> I have sent this out before and kbuildbot didn't find any issues. 
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit fdd0bd88ceaecf729db103ac8836af5805dd2dc1:
>
>   brcmfmac: add CLM download support (2017-11-11 03:04:09 +0200)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2017-11-19

Pulled, thanks.

-- 
Kalle Valo
