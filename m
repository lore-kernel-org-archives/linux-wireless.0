Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44504 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750762AbdGULek (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Jul 2017 07:34:40 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Subject: Re: pull-request: iwlwifi 2017-07-21
References: <1500629777.22048.324.camel@coelho.fi>
Date: Fri, 21 Jul 2017 14:34:35 +0300
In-Reply-To: <1500629777.22048.324.camel@coelho.fi> (Luca Coelho's message of
        "Fri, 21 Jul 2017 12:36:17 +0300")
Message-ID: <87h8y62fck.fsf@kamboji.qca.qualcomm.com> (sfid-20170721_133444_040951_4D51E555)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Here are some fixes for 4.13.  More details in the tag description.
>
> I have sent this out before and kbuildbot didn't find any issues. 
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 271612d72da5b46715447bc18add4a1cf7d87687:
>
>   Revert "rtlwifi: btcoex: rtl8723be: fix ant_sel not work" (2017-07-21 10:41:43 +0300)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2017-07-21
>
> for you to fetch changes up to bf8b286f86fcc66d138fd992acfa37839340218d:
>
>   iwlwifi: mvm: defer setting IWL_MVM_STATUS_IN_HW_RESTART (2017-07-21 12:26:39 +0300)
>
> ----------------------------------------------------------------
> Some iwlwifi fixes for 4.13:
>
> * A few NULL pointer dereferences in the recovery flow;
> * A small but important fix for IBSS;
> * A one-liner fix for tracing, which was including too much data;
> * Some of these are bugzilla bug fixes;
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
