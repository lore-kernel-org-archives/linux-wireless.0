Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55488 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754940AbdLGNwF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Dec 2017 08:52:05 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Subject: Re: pull-request: iwlwifi 2017-12-05
References: <1512484624.4827.187.camel@coelho.fi>
Date: Thu, 07 Dec 2017 15:52:01 +0200
In-Reply-To: <1512484624.4827.187.camel@coelho.fi> (Luca Coelho's message of
        "Tue, 05 Dec 2017 16:37:04 +0200")
Message-ID: <877etyve66.fsf@kamboji.qca.qualcomm.com> (sfid-20171207_145245_619340_4D693784)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Here is my third set of fixes for 4.15.  The most important fixes are
> for the new 9000 series where we were not handling some offloads
> correctly and secure connections were totally broken.  There is also 4
> new PCI IDs and an ROC fix on P2P.  More details in the tag
> description.
>
> I have sent this out before and kbuildbot didn't find any issues. 
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 5c3de777bdaf48bd0cfb43097c0d0fb85056cab7:
>
>   brcmfmac: change driver unbind order of the sdio function devices (2017-12-02 17:22:47 +0200)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2017-12-05
>
> for you to fetch changes up to bf19037074e770aad74b3b90f37b8b98db3f3748:
>
>   iwlwifi: mvm: mark MIC stripped MPDUs (2017-12-05 16:23:30 +0200)
>
> ----------------------------------------------------------------
> Third batch of iwlwifi patches intended for 4.15.
>
> * Tell mac80211 when the MAC has been stripped (9000 series);
> * Tell mac80211 when the IVC has been stripped (9000 series);
> * Add 2 new PCI IDs, one for 9000 and one for 22000;
> * Fix a queue hang due during ROC.
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
