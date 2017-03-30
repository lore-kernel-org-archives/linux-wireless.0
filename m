Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53256 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932792AbdC3QmQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Mar 2017 12:42:16 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: iwlwifi 2017-03-29
References: <1490784401.13345.6.camel@coelho.fi>
Date: Thu, 30 Mar 2017 19:42:09 +0300
In-Reply-To: <1490784401.13345.6.camel@coelho.fi> (Luca Coelho's message of
        "Wed, 29 Mar 2017 13:46:41 +0300")
Message-ID: <87zig2som6.fsf@kamboji.qca.qualcomm.com> (sfid-20170330_184219_537521_03FC072F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Hi Kalle,
>
> Here are some fixes for 4.11.  More details in the tag description.
>
> I have sent this out before and kbuildbot didn't find any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 6be3b6cce1e225f189b68b4e84fc711d19b4277b:
>
>   ath10k: fix incorrect wlan_mac_base in qca6174_regs (2017-03-20 17:11:31 +0200)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2017-03-29
>
> for you to fetch changes up to 4d339989acd730f17bc814b5ddb9c54e405766b6:
>
>   iwlwifi: mvm: support ibss in dqa mode (2017-03-24 17:15:25 +0200)
>
> ----------------------------------------------------------------
> iwlwifi fixes for 4.11
>
> Here are three patches intended for 4.11.  The first one is an RCU fix
> by Sari.  The second one is a fix for a potential out-of-bounds access
> crash by Dan.  And finally, the third and bigger one, is a fix for
> IBSS, which has been broken since DQA was enabled in the driver.
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
