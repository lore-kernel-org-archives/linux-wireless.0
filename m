Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47948 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933893AbdA0Lal (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 06:30:41 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Subject: Re: pull-request: iwlwifi-next 2017-01-26
References: <1485462650.26003.11.camel@coelho.fi>
Date: Fri, 27 Jan 2017 13:24:19 +0200
In-Reply-To: <1485462650.26003.11.camel@coelho.fi> (Luca Coelho's message of
        "Thu, 26 Jan 2017 22:30:50 +0200")
Message-ID: <87lgtw7nks.fsf@kamboji.qca.qualcomm.com> (sfid-20170127_123152_697955_304AD531)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Hi Kalle,
>
> Here's my first pull-request intended for v4.11.  It has a bunch of
> fixes, cleanups and improvements here and there, as well as a few new
> features.  More details in the tag description.
>
> I have sent this out before and kbuildbot didn't find any issues.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 106e0deca1ac6ac627a10617fe77a95200cb01a7:
>
>   rtlwifi: rtl8192cu: Convert driver to use common macros (2017-01-20 12:06:10 +0200)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2017-01-26
>
> for you to fetch changes up to 758c98e089389e90732fe45087fdee3177493a81:
>
>   iwlwifi: mvm: cleanup redundant assignment (2017-01-26 09:39:02 +0200)
>
> ----------------------------------------------------------------
> Some improvements, bugfixes and new features:
>  * A bunch of cleanups here and there;
>  * A few simple bugfixes;
>  * Some more work in preparation for A000 family support;
>  * Add support for radiotap timestamps;
>  * Some work on our firmware debugging capabilities;
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
