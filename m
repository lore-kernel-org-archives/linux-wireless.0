Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43268 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752488AbdLHMab (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Dec 2017 07:30:31 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Wireless <linux-wireless@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ihab Zhaika <ihab.zhaika@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: linux-next: manual merge of the wireless-drivers-next tree with the wireless-drivers tree
References: <20171208120034.499e1a65@canb.auug.org.au>
Date: Fri, 08 Dec 2017 14:30:26 +0200
In-Reply-To: <20171208120034.499e1a65@canb.auug.org.au> (Stephen Rothwell's
        message of "Fri, 8 Dec 2017 12:00:34 +1100")
Message-ID: <877etxs8pp.fsf@kamboji.qca.qualcomm.com> (sfid-20171208_133059_003004_9F009F36)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Today's linux-next merge of the wireless-drivers-next tree got a
> conflict in:
>
>   drivers/net/wireless/intel/iwlwifi/pcie/drv.c
>
> between commit:
>
>   567deca8e72d ("iwlwifi: add new cards for 9260 and 22000 series")
>
> from the wireless-drivers tree and commit:
>
>   2f7a3863191a ("iwlwifi: rename the temporary name of A000 to the official 22000")
>
> from the wireless-drivers-next tree.
>
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

The fix looks good, thanks! I'll try to resolve the conflict before I
send a wireless-drivers-next pull request to Dave.

-- 
Kalle Valo
