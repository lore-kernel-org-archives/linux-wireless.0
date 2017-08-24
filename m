Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:49209 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750715AbdHXBcR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Aug 2017 21:32:17 -0400
Date: Thu, 24 Aug 2017 11:32:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: linux-next: manual merge of the wireless-drivers-next tree with
 Linus' tree
Message-ID: <20170824113214.352b5c18@canb.auug.org.au> (sfid-20170824_033231_536697_40A977C5)
In-Reply-To: <20170824111753.2b1c508e@canb.auug.org.au>
References: <20170824111753.2b1c508e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

On Thu, 24 Aug 2017 11:17:53 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
>   		IWL_DEBUG_DEV(dev, IWL_DL_LAR,
> - 			      "Ch. %d [%sGHz] %s%s%s%s%s%s%s%s%s(0x%02x) reg_flags 0x%x: %s\n",
>  -			      "Ch. %d [%sGHz] %s%s%s%s%s%s%s%s%s%s%s%s(0x%02x): %s\n",
> ++			      "Ch. %d [%sGHz] %s%s%s%s%s%s%s%s%s%s%s%s(0x%02x) reg_flags 0x%x: %s\n"

Rats! I missed the comma ... I have added it back.

-- 
Cheers,
Stephen Rothwell
