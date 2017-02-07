Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51732 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751606AbdBGHdA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 02:33:00 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Subject: Re: pull-request: iwlwifi-next 2017-02-06
References: <1486402642.26003.141.camel@coelho.fi>
Date: Tue, 07 Feb 2017 09:32:55 +0200
In-Reply-To: <1486402642.26003.141.camel@coelho.fi> (Luca Coelho's message of
        "Mon, 06 Feb 2017 19:37:22 +0200")
Message-ID: <87tw8678wo.fsf@codeaurora.org> (sfid-20170207_083304_410258_B7F11C46)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Here's my second pull-request intended for v4.11.  Just the usual set of
> fixes, cleanups and improvements, together with the continued work on
> support for new hardware.  A bit more details in the tag description.
>
> I have sent this out before and kbuildbot didn't find any issues.  I
> have also removed my favorite mistakes, namely the "commit" after the
> Fixes tag. ;)
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 36401cb7ffae731295a6dd1ce2b40d7ad74245f4:
>
>   brcmfmac: be more verbose when PSM's watchdog fires (2017-02-02 08:14:26 +0200)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2017-02-06
>
> for you to fetch changes up to 8364fbb497f00de21d6d347194fa8b6bbae1d6f5:
>
>   iwlwifi: mvm: support new beacon template command (2017-02-06 19:19:27 +0200)
>
> ----------------------------------------------------------------
> Second batch of improvements and fixes for v4.11.
>
>   * A bunch of bugfixes for the DQA code;
>   * Work on support for new A000 devices continues;
>   * Some clean-ups and general improvements
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
