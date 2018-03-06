Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37536 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753243AbeCFPPP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Mar 2018 10:15:15 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Subject: Re: pull-request: iwlwifi 2018-03-02
References: <1519981045.6017.4.camel@coelho.fi>
Date: Tue, 06 Mar 2018 17:15:06 +0200
In-Reply-To: <1519981045.6017.4.camel@coelho.fi> (Luca Coelho's message of
        "Fri, 02 Mar 2018 10:57:25 +0200")
Message-ID: <877eqpjkw5.fsf@kamboji.qca.qualcomm.com> (sfid-20180306_161518_912829_C4088D2C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Hi Kalle,
>
> Here is my second set of fixes for 4.16.  More details in the tag
> description.
>
> I have sent this out before and kbuildbot didn't find any issues. 
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 78dc897b7ee67205423dbbc6b56be49fb18d15b5:
>
>   rtlwifi: rtl8723be: Fix loss of signal (2018-02-25 09:47:15 +0200)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2018-03-02
>
> for you to fetch changes up to de655fa8fb237d0eaf838e8833b464c1dec90070:
>
>   iwlwifi: fix malformed CONFIG_IWLWIFI_PCIE_RTPM default (2018-03-02 10:20:03 +0200)
>
> ----------------------------------------------------------------
> Second batch of iwlwifi fixes intended for 4.16:
>
> * Fix CSA issues with count 0 and 1;
> * Some firmware debugging fixes;
> * Removed a wrong error message when removing keys;
> * Fix a firmware sysassert most usually triggered in IBSS;
> * A couple of fixes on multicast queues;
> * A fix with CCMP 256;
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
