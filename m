Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33716 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbcEJGnY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 02:43:24 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Sara Sharon <sara.sharon@intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: linux-next: manual merge of the net-next tree with the wireless-drivers tree
References: <20160509103921.72146ce1@canb.auug.org.au>
Date: Tue, 10 May 2016 09:43:16 +0300
In-Reply-To: <20160509103921.72146ce1@canb.auug.org.au> (Stephen Rothwell's
	message of "Mon, 9 May 2016 10:39:21 +1000")
Message-ID: <87futqh0qj.fsf@kamboji.qca.qualcomm.com> (sfid-20160510_084346_392869_4ED59C4C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Today's linux-next merge of the net-next tree got a conflict in:
>
>   drivers/net/wireless/intel/iwlwifi/mvm/tx.c
>
> between commit:
>
>   5c08b0f5026f ("iwlwifi: mvm: don't override the rate with the AMSDU len")
>
> from the wireless-drivers tree and commit:
>
>   d8fe484470dd ("iwlwifi: mvm: add support for new TX CMD API")
>
> from the net-next tree.
>
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

I'm planning to fix this by merging wireless-drivers to
wireless-drivers-next later today and most likely tomorrow send a
wireless-drivers-next pull request to Dave.

-- 
Kalle Valo
