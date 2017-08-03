Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50866 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751200AbdHCICO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 04:02:14 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Subject: Re: pull-request: iwlwifi 2017-08-02
References: <1501699577.15969.23.camel@coelho.fi>
Date: Thu, 03 Aug 2017 11:02:09 +0300
In-Reply-To: <1501699577.15969.23.camel@coelho.fi> (Luca Coelho's message of
        "Wed, 02 Aug 2017 21:46:17 +0300")
Message-ID: <87mv7hoz9a.fsf@kamboji.qca.qualcomm.com> (sfid-20170803_100224_678527_D3CD3A00)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Hi Kalle,
>
> Here is my second batch of fixes for 4.13.  More details in the tag description.
>
> I have sent this out before and kbuildbot didn't find any issues. 
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 5f5d03143de5e0c593da4ab18fc6393c2815e108:
>
>   brcmfmac: fix memleak due to calling brcmf_sdiod_sgtable_alloc() twice (2017-07-27 14:03:14 +0300)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2017-08-02
>
> for you to fetch changes up to 558f479f687aca6a336e13309424a7c3afd32721:
>
>   iwlwifi: add the new 9000 series PCI IDs (2017-08-01 12:26:17 +0300)
>
> ----------------------------------------------------------------
> Some fixes in iwlwifi for 4.13
>
> * Some simple PCI HW ID fix-ups and additions for family 9000;
> * A couple of bugzilla fixes:
>   - Remove a bogus warning message with new FWs (196915)
>   - Don't allow illegal channel options to be used (195299)
> * A fix for checksum offload in family 9000;
> * A fix serious throughput degradation in 11ac with multiple streams;
> * An old bug in SMPS where the firmware was not aware of SMPS changes;
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
