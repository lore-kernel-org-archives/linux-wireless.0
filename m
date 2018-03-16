Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42804 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750748AbeCPMlw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Mar 2018 08:41:52 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Subject: Re: pull-request: iwlwifi 2018-03-16
References: <1521197408.3786.26.camel@coelho.fi>
Date: Fri, 16 Mar 2018 14:41:47 +0200
In-Reply-To: <1521197408.3786.26.camel@coelho.fi> (Luca Coelho's message of
        "Fri, 16 Mar 2018 12:50:08 +0200")
Message-ID: <87605w2nw4.fsf@kamboji.qca.qualcomm.com> (sfid-20180316_134155_964482_DCF92D26)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Here is my third set of fixes for 4.16.  More details in the tag
> description.
>
> I have sent this out before and kbuildbot didn't find any issues. 
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 87de1201ddaa39d4f3fafa9f35ac143e582517e6:
>
>   Merge branch 'erspan-fixes' (2018-03-09 13:03:57 -0500)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2018-03-16
>
> for you to fetch changes up to 86a2b2043af79deff5cf000c5a08847faa4f2ee0:
>
>   iwlwifi: add shared clock PHY config flag for some devices (2018-03-16 12:34:54 +0200)
>
> ----------------------------------------------------------------
> Third batch of iwlwifi fixes intended for 4.16:
>
> * Fix an issue with the multicast queue;
> * Fix IGTK handling;
> * Fix some missing return value checks;
> * Add support for a HW workaround for issues on some platforms;
>
> ----------------------------------------------------------------

Pulled, thanks.

BTW, I'm hoping to submit the last pull request for 4.16 next Thursday.
So if there are patches for 4.16 please submit them before Thursday.

-- 
Kalle Valo
