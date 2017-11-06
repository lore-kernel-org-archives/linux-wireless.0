Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44780 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750729AbdKFKiO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Nov 2017 05:38:14 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com
Subject: Re: pull-request: iwlwifi-next 2017-11-03
References: <1509703364.4492.350.camel@coelho.fi>
Date: Mon, 06 Nov 2017 12:38:10 +0200
In-Reply-To: <1509703364.4492.350.camel@coelho.fi> (Luca Coelho's message of
        "Fri, 03 Nov 2017 12:02:44 +0200")
Message-ID: <87k1z3k7zh.fsf@codeaurora.org> (sfid-20171106_113818_247973_345CA4E2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Here's the final set of patches intended for v4.15.  It's not too
> important to get them into v4.15 if there is no time anymore.  There
> are a few new PCI IDs that can be added in the rc series or stable
> (they need to go to other stable releases anyway).  And there's also
> one bugfix that I could also send to rc.  The rest are just cleanups,
> improvements or related to the A000 series.  Let me know how it goes
> and I'll adapt if needed.
>
> I have sent this out before and kbuildbot reported success.
>
> Please let me know if there are any issues.

As you know we got one more week before the merge window starts, so I
should get this to v4.15.

> The following changes since commit e226fb5affccca98c405de80527180224d93d251:
>
>   Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2017-11-02 19:48:25 +0200)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2017-11-03
>
> for you to fetch changes up to 57b36f7fcb39c5eae8c1f463699f747af69643ba:
>
>   iwlwifi: add new cards for a000 series (2017-11-03 11:56:10 +0200)
>
> ----------------------------------------------------------------
> iwlwifi updates
>
> * Some new PCI IDs;
> * A bunch of cleanups;
> * The timers update by Kees;
> * Add more register dump call-sites;
> * A fix for a locking issue in the TX flush code;
> * Actual implementation of the TX flush code for A000;
> * An optimization to drop RX frames during restart to avoid BA issues;
>
> ----------------------------------------------------------------
> Emmanuel Grumbach (3):
>       iwlwifi: mvm: rs: remove the ANT C from the toogle antenna logic
>       iwlwifi: remove dead code for internal devices only
>       iwlwifi: remove host assisted paging
>
> Ihab Zhaika (3):
>       iwlwifi: add new cards for 8260 series
>       iwlwifi: add new cards for 8265 series
>       iwlwifi: add new cards for a000 series
>
> Kees Cook (1):
>       iwlwifi: mvm: Convert timers to use timer_setup()
>
> Kirtika Ruchandani (1):
>       iwlwifi: Add more call-sites for pcie reg dumper
>
> Liad Kaufman (1):
>       iwlwifi: mvm: reset seq num after restart
>
> Luca Coelho (1):
>       iwlwifi: mvm: hold mutex when flushing in iwl_mvm_flush_no_vif()
>
> Sara Sharon (6):
>       iwlwifi: mvm: use RS macro instead of duplicating the code
>       iwlwifi: mvm: cleanup references to aggregation count limit
>       iwlwifi: mvm: improve latency when there is a reorder timeout
>       iwlwifi: fix multi queue notification for a000 devices
>       iwlwifi: mvm: refactor iwl_mvm_flush_no_vif
>       iwlwifi: mvm: add missing implementation of flush for a000 devices
>
> Shahar S Matityahu (1):
>       iwlwifi: drop RX frames during hardware restart

Pulled, thanks.

-- 
Kalle Valo
