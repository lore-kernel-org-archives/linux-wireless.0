Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53472 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750762AbeBYHpH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Feb 2018 02:45:07 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Subject: Re: pull-request: iwlwifi 2018-02-16-2
References: <1518793739.7832.59.camel@coelho.fi>
Date: Sun, 25 Feb 2018 09:45:02 +0200
In-Reply-To: <1518793739.7832.59.camel@coelho.fi> (Luca Coelho's message of
        "Fri, 16 Feb 2018 17:08:59 +0200")
Message-ID: <87zi3xv7gh.fsf@kamboji.qca.qualcomm.com> (sfid-20180225_084510_833237_A68E324F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Hi Kalle,
>
> Here is v2 ofmy first set of fixes for 4.16.  More details in the tag
> description.
>
> This fixes a compilation problem that was found by kbuildbot (missing
> include in in mvm.h on "iwlwifi: align timestamp cancel with timestamp
> start").
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 7ac8ff95f48cbfa609a060fd6a1e361dd62feeb3:
>
>   mvpp2: fix multicast address filter (2018-02-11 22:37:04 -0500)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2018-02-16-2

Pulled, thanks.

-- 
Kalle Valo
