Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52055 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbcGGQKh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2016 12:10:37 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Xinming Hu <huxm@marvell.com>,
	Avraham Stern <avraham.stern@intel.com>,
	David Spinadel <david.spinadel@intel.com>,
	Assaf Krauss <assaf.krauss@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	linux-wireless@vger.kernel.org
Subject: Re: linux-next: manual merge of the mac80211-next tree with the wireless-drivers-next tree
References: <20160707115628.7fdac327@canb.auug.org.au>
Date: Thu, 07 Jul 2016 19:10:24 +0300
In-Reply-To: <20160707115628.7fdac327@canb.auug.org.au> (Stephen Rothwell's
	message of "Thu, 7 Jul 2016 11:56:28 +1000")
Message-ID: <874m812zv3.fsf@kamboji.qca.qualcomm.com> (sfid-20160707_181106_861591_1787A041)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Adding linux-wireless)

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Johannes,
>
> Today's linux-next merge of the mac80211-next tree got a conflict in:
>
>   drivers/net/wireless/marvell/mwifiex/cmdevt.c
>
> between commit:
>
>   a9c790ba23eb ("mwifiex: factor out mwifiex_cancel_scan")
>
> from the wireless-drivers-next tree and commit:
>
>   1d76250bd34a ("nl80211: support beacon report scanning")
>
> from the mac80211-next tree.
>
> I fixed it up (I used the wireless-drivers-next tree version of this file
> and then added the following merge fix patch) and can carry the fix as
> necessary. This is now fixed as far as linux-next is concerned, but any
> non trivial conflicts should be mentioned to your upstream maintainer
> when your tree is submitted for merging.  You may also want to consider
> cooperating with the maintainer of the conflicting tree to minimise any
> particularly complex conflicts.

Thanks. When I send my pull request to Dave I'll let him know about this
conflict and propose to use your patch as the resolution.

Stephen, if it's not too much trouble for you it would be good to CC
linux-wireless on wireless related problems. Not everyone follow lkml
(or linux-next).

-- 
Kalle Valo
