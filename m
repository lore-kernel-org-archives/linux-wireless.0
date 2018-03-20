Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36246 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751916AbeCTKCe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 06:02:34 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Subject: Re: pull-request: iwlwifi 2018-03-19
References: <1521449644.3786.110.camel@coelho.fi>
Date: Tue, 20 Mar 2018 12:02:30 +0200
In-Reply-To: <1521449644.3786.110.camel@coelho.fi> (Luca Coelho's message of
        "Mon, 19 Mar 2018 10:54:04 +0200")
Message-ID: <87lgenxdxl.fsf@kamboji.qca.qualcomm.com> (sfid-20180320_110237_979443_DCA3E658)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Here is my fourth set of fixes for 4.16.  More details in the tag
> description.
>
> I have sent this out before and kbuildbot didn't find any issues. 
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 1259055170287a350cad453e9eac139c81609860:
>
>   brcmfmac: drop Inter-Access Point Protocol packets by default (2018-03-16 15:00:24 +0200)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2018-03-19
>
>
> for you to fetch changes up to 9f4ef1d70f05ebb7f0755545c05ea383be0eeb0f:
>
>   iwlwifi: mvm: Move unused phy's to a default channel (2018-03-19 10:50:38 +0200)
>
> ----------------------------------------------------------------
> Fourth batch of iwlwifi fixes intended for 4.16:
>
> * a couple of fixes for channel-switch;
> * a few fixes for the aggregation handling code;
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
