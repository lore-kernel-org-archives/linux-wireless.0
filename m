Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36446 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751499AbdIRLK7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Sep 2017 07:10:59 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Subject: Re: pull-request: iwlwifi 2017-09-15
References: <1505476034.5400.291.camel@coelho.fi>
Date: Mon, 18 Sep 2017 14:10:54 +0300
In-Reply-To: <1505476034.5400.291.camel@coelho.fi> (Luca Coelho's message of
        "Fri, 15 Sep 2017 14:47:14 +0300")
Message-ID: <87tw00dzy9.fsf@kamboji.qca.qualcomm.com> (sfid-20170918_131103_000833_28509546)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Here is the first set of fixes for 4.14.  More details in the tag
> description.
>
> I have sent this out before and kbuildbot didn't find any issues. 
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 2eabc84d2f8e4f36d3719eeb6a330e10c46c8da7:
>
>   iwlwifi: mvm: only send LEDS_CMD when the FW supports it (2017-09-07 19:40:09 +0300)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2017-09-15
>
> for you to fetch changes up to 5f90472c00ddf1e64c2865f71cced297bd5f80a2:
>
>   iwlwifi: mvm: fix reorder buffer for 9000 devices (2017-09-08 11:52:51 +0300)
>
> ----------------------------------------------------------------
> First set of fixes for 4.14
>
> * A couple of bugzilla bugs related to multicast handling;
> * Two fixes for WoWLAN bugs that were causing queue hangs and
>   re-initialization problems;
> * Two fixes for potential uninitialized variable use reported by Dan
>   Carpenter in relation to a recently introduced patch;
> * A fix for buffer reordering in the newly supported 9000 device
>   family;
> * Fix a race when starting aggregation;
> * Small fix for a recent patch to wake mac80211 queues;
> * Send non-bufferable management frames in the generic queue so they
>   are not sent on queues that are under power-save;
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
