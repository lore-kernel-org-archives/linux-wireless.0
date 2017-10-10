Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41422 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751900AbdJJF4Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Oct 2017 01:56:16 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Subject: Re: pull-request: iwlwifi 2017-10-06
References: <1507288582.908.127.camel@coelho.fi>
Date: Tue, 10 Oct 2017 08:56:10 +0300
In-Reply-To: <1507288582.908.127.camel@coelho.fi> (Luca Coelho's message of
        "Fri, 06 Oct 2017 14:16:22 +0300")
Message-ID: <87r2ub4kcl.fsf@codeaurora.org> (sfid-20171010_075620_620726_560C3C6E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Here is the second set of fixes for 4.14.  More details in the tag
> description.
>
> I have sent this out before and kbuildbot didn't find any issues. 
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit c503dd38f850be28867ef7a42d9abe5ade81a9bd:
>
>   brcmsmac: make some local variables 'static const' to reduce stack size (2017-10-02 16:52:55 +0300)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2017-10-06
>
> for you to fetch changes up to 44fd09dad5d2b78efbabbbbf623774e561e36cca:
>
>   iwlwifi: nvm: set the correct offsets to 3168 series (2017-10-06 13:59:44 +0300)
>
> ----------------------------------------------------------------
> Second set of iwlwifi fixes for 4.14
>
> * Fix support for 3168 device series;
> * Fix a potential crash when using FW debugging recording;
> * Improve channel flags parsing to avoid warnings on too long traces;
> * Return -ENODATA when the temperature is not available, since the
>   -EIO we were returning was causing fatal errors in userspace;
> * Avoid printing too many messages in dmesg when using monitor mode,
>   since this can become very noisy and completely flood the logs;
>
> ----------------------------------------------------------------

Pulled, thanks.

Actually I pulled this already yesterday but forgot to reply.

-- 
Kalle Valo
