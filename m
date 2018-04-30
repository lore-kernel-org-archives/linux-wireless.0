Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47874 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbeD3KEd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 06:04:33 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Subject: Re: pull-request: iwlwifi-next 2018-04-26
References: <d70efddcc5ef39561504f61eb0069281b76d8ce2.camel@coelho.fi>
Date: Mon, 30 Apr 2018 13:04:27 +0300
In-Reply-To: <d70efddcc5ef39561504f61eb0069281b76d8ce2.camel@coelho.fi> (Luca
        Coelho's message of "Thu, 26 Apr 2018 15:45:34 +0300")
Message-ID: <87r2mx3t90.fsf@kamboji.qca.qualcomm.com> (sfid-20180430_120437_414210_C987AD05)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> This is the second batch of patches intended for v4.18.  Nothing major
> here, just the usual continued development, bugfixes, new FW APIs and
> some new features.  More details about the contents in the tag
> description.
>
> I have sent this out before and kbuildbot reported success.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 0ddcf3e76ae4d02918e609342a1020b50258fadd:
>
>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git (2018-04-26 13:26:37 +0300)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2018-04-26
>
> for you to fetch changes up to d3a6f7fb97fc34a38e40cc56392e701598f99863:
>
>   iwlwifi: mvm: set wakeup filters for wowlan "any" configuration (2018-04-26 15:18:07 +0300)
>
> ----------------------------------------------------------------
> Second batch of iwlwifi patches for 4.18
>
> * Some preparations for new hardware;
> * A workaround to rescan the bus for the rare situation when older
>   devices become irresponsive,
> * Hardening of the firmware loading code to avoid issues with
>   corrupted files;
> * A few clean-ups and bugfixes.
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
