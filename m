Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55304 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751649AbdLBNDg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 08:03:36 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Subject: Re: pull-request: iwlwifi 2017-11-28
References: <1511871780.4011.426.camel@coelho.fi>
Date: Sat, 02 Dec 2017 15:03:32 +0200
In-Reply-To: <1511871780.4011.426.camel@coelho.fi> (Luca Coelho's message of
        "Tue, 28 Nov 2017 14:23:00 +0200")
Message-ID: <87lgilwacb.fsf@kamboji.qca.qualcomm.com> (sfid-20171202_140340_661297_FD3697A9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Here is my second set of fixes for 4.15.  More details in the tag
> description.
>
> I have sent this out before and kbuildbot didn't find any issues. 
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit ed59b7d53c95548d83d4e7e1bc5edafcdcad09c9:
>
>   Merge ath-current from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2017-11-21 11:52:18 +0200)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2017-11-28
>
> for you to fetch changes up to 0232d2cd7aa8e1b810fe84fb4059a0bd1eabe2ba:
>
>   iwlwifi: fix access to prph when transport is stopped (2017-11-25 17:12:56 +0200)
>
> ----------------------------------------------------------------
> Second batch of fixes intended for 4.15.
>
> * One fix in rate-scaling;
> * One fix for the TX queue hang detection for AP/GO modes;
> * Fix the TX queue hang timeout used in monitor interfaces;
> * Fix packet injection;
> * Remove a wrong error message when dumping PCI registers;
> * Fix race condition with RF-kill;
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
