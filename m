Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33212 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751684AbdLBN1Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 08:27:25 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, janet.morgan@intel.com, joe.konno@intel.com
Subject: Re: pull-request: iwlwifi-next 2017-11-29
References: <1511943359.4827.18.camel@coelho.fi>
Date: Sat, 02 Dec 2017 15:27:20 +0200
In-Reply-To: <1511943359.4827.18.camel@coelho.fi> (Luca Coelho's message of
        "Wed, 29 Nov 2017 10:15:59 +0200")
Message-ID: <87h8t9w98n.fsf@kamboji.qca.qualcomm.com> (sfid-20171202_142729_024754_C839C8B4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> This is my first batch of patches intended for v4.16.  As I mentioned
> in the patchset thread, I removed patch 08/11 because it was broken. 
> More details about the contents in the tag description.
>
> I have sent this out before and kbuildbot reported success.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit fdd0bd88ceaecf729db103ac8836af5805dd2dc1:
>
>   brcmfmac: add CLM download support (2017-11-11 03:04:09 +0200)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2017-11-29
>
> for you to fetch changes up to 2f7a3863191afc2c132854b7ffb1b867b4b9e8be:
>
>   iwlwifi: rename the temporary name of A000 to the official 22000 (2017-11-28 16:39:57 +0200)
>
> ----------------------------------------------------------------
> First batch of iwlwifi updates for v4.16
>
> * Rename the temporary name A000 to 22000;
> * Change in the way we print the firmware version;
> * Remove some unused code;
> * Other small improvements;
>
> ----------------------------------------------------------------

Pulled, thanks.

But there were few conflicts due to my fast forward from yesterday,
please check my resolution. I tried to be careful that fixes in
c2c48ddfc8b0 ("iwlwifi: fix firmware names for 9000 and A000 series hw")
won't get lost.

$ git pull git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2017-11-29
>From git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
 * tag                         iwlwifi-next-for-kalle-2017-11-29 -> FETCH_HEAD
Auto-merging drivers/net/wireless/intel/iwlwifi/pcie/trans.c
Auto-merging drivers/net/wireless/intel/iwlwifi/pcie/drv.c
Auto-merging drivers/net/wireless/intel/iwlwifi/mvm/tx.c
Auto-merging drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
Auto-merging drivers/net/wireless/intel/iwlwifi/iwl-config.h
CONFLICT (content): Merge conflict in drivers/net/wireless/intel/iwlwifi/iwl-config.h
Auto-merging drivers/net/wireless/intel/iwlwifi/fw/file.h
CONFLICT (modify/delete): drivers/net/wireless/intel/iwlwifi/cfg/a000.c deleted in ca495785063c428641cc6df8888afd2587ca6677 and modified in HEAD. Version HEAD of drivers/net/wireless/intel/iwlwifi/cfg/a000.c left in tree.
Recorded preimage for 'drivers/net/wireless/intel/iwlwifi/iwl-config.h'
Automatic merge failed; fix conflicts and then commit the result.

-- 
Kalle Valo
