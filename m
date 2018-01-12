Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41932 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754503AbeALLb1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Jan 2018 06:31:27 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>, emmanuel.grumbach@intel.com
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 0/5] iwlwifi: updates intended for v4.16 2017-12-23
References: <20171223092200.30270-1-luca@coelho.fi>
Date: Fri, 12 Jan 2018 13:31:23 +0200
In-Reply-To: <20171223092200.30270-1-luca@coelho.fi> (Luca Coelho's message of
        "Sat, 23 Dec 2017 11:21:55 +0200")
Message-ID: <871sivs48k.fsf@kamboji.qca.qualcomm.com> (sfid-20180112_123131_188374_23D58B6E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ emmanuel

Luca Coelho <luca@coelho.fi> writes:

> From: Luca Coelho <luciano.coelho@intel.com>
>
> Hi,
>
> Here's the fourth and probably last batch of patches intended for
> 4.16.  Nothing major, just continued development, some cleanups and
> small fixes here and there.
>
> * Fix a UBSAN warning;
> * Improvement in the net-stack/driver log syncing
> * An RCU lock fix in the new rate-scaling code;
> * Small cleanups;
>
> As usual, I'm pushing this to a pending branch, for kbuild bot, and
> will send a pull-request later.
>
> FYI, I'll be on holidays/vacations for the next few weeks, so there
> will probably not be much activity in the iwlwifi driver code.
>
> Please review.
>
> Cheers,
> Luca.
>
>
> Luca Coelho (1):
>   iwlwifi: mvm: check if mac80211_queue is valid in iwl_mvm_disable_txq
>
> Mordechay Goodstein (1):
>   iwlwifi: set default timstamp marker cmd
>
> Sara Sharon (3):
>   iwlwifi: mvm: flip AMSDU addresses only for 9000 family
>   iwlwifi: mvm: take RCU lock before dereferencing
>   iwlwifi: mvm: move TSO segment to a separate function

Most likely the merge window starts in 9 days so I need to start getting
patches ready. As Luca is away should I apply these patches directly to
wireless-drivers-next?

-- 
Kalle Valo
