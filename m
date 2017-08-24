Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59398 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751124AbdHXHpB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 03:45:01 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Wireless <linux-wireless@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        David Miller <davem@davemloft.net>
Subject: Re: linux-next: manual merge of the wireless-drivers-next tree with Linus' tree
References: <20170824111753.2b1c508e@canb.auug.org.au>
Date: Thu, 24 Aug 2017 10:44:55 +0300
In-Reply-To: <20170824111753.2b1c508e@canb.auug.org.au> (Stephen Rothwell's
        message of "Thu, 24 Aug 2017 11:17:53 +1000")
Message-ID: <87poblflzc.fsf@codeaurora.org> (sfid-20170824_094516_296317_F325D193)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Adding Dave so that he is also aware of this)

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> As expetced, today's linux-next merge of the wireless-drivers-next tree
> got a conflict in:
>
>   drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
>
> between commit:
>
>   92b0f7b26b31 ("iwlwifi: split the regulatory rules when the bandwidth flags require it")
>
> from Linus' tree and commit:
>
>   b823cf3bae81 ("iwlwifi: update channel flags parser")
>
> from the wireless-drivers-next tree.
>
> I fixed it up (see below - Luca, Kalle, thanks for the heads up) and
> can carry the fix as necessary. This is now fixed as far as linux-next
> is concerned, but any non trivial conflicts should be mentioned to your
> upstream maintainer when your tree is submitted for merging.  You may
> also want to consider cooperating with the maintainer of the conflicting
> tree to minimise any particularly complex conflicts.

Thanks for the report. There were quite a few conflicts in iwlwifi so
I'm planning to merge wireless-drivers to wireless-drivers-next today so
that the conflicts are fixed before I submit them to Dave.

-- 
Kalle Valo
