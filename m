Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34982 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751555AbdHITkE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Aug 2017 15:40:04 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Subject: Re: pull-request: iwlwifi 2017-08-09
References: <1502264372.15969.167.camel@coelho.fi>
Date: Wed, 09 Aug 2017 22:39:58 +0300
In-Reply-To: <1502264372.15969.167.camel@coelho.fi> (Luca Coelho's message of
        "Wed, 09 Aug 2017 10:39:32 +0300")
Message-ID: <871sokil81.fsf@kamboji.qca.qualcomm.com> (sfid-20170809_214008_113196_D1F7A408)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Here is the third set of fixes for 4.13.  More details in the tag
> description.
>
> This includes both series I sent out, the first one, with v2 of the
> second patch, with an improved commit message, and the second one, which
> contains the mac80211 patch as well.
>
> I have sent this out before and kbuildbot didn't find any issues. 
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 368bd88ebb64cabe4a1ec727659214bb8d693707:
>
>   Merge tag 'iwlwifi-for-kalle-2017-08-02' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes (2017-08-03 11:01:11 +0300)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2018-08-09
>
> for you to fetch changes up to 20fc690f38d17b8f961101a477a9aa0841fb6e20:
>
>   iwlwifi: mvm: send delba upon rx ba session timeout (2017-08-09 10:05:01 +0300)
>
> ----------------------------------------------------------------
> Some more fixes for 4.13
>
> * Fix a memory leak in the SAR code;
> * Fix a stuck queue case in AP mode;
> * Convert a WARN to a simple debug in a legitimate race case (from
>   which we can recover);
> * Fix a severe throughput aggregation on 9000-family devices due to
>   aggregation issues.
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
