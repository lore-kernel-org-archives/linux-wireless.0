Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51199 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbcGKIDb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 04:03:31 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: <linux-wireless@vger.kernel.org>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Avraham Stern <avraham.stern@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Assaf Krauss <assaf.krauss@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Subject: Re: linux-next: manual merge of the wireless-drivers-next tree with the net-next tree
References: <20160711120614.0cdca5fa@canb.auug.org.au>
Date: Mon, 11 Jul 2016 11:03:24 +0300
In-Reply-To: <20160711120614.0cdca5fa@canb.auug.org.au> (Stephen Rothwell's
	message of "Mon, 11 Jul 2016 12:06:14 +1000")
Message-ID: <87vb0czjn7.fsf@kamboji.qca.qualcomm.com> (sfid-20160711_100352_660407_5C4DF712)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Today's linux-next merge of the wireless-drivers-next tree got a
> conflict in:
>
>   drivers/net/wireless/intel/iwlwifi/mvm/scan.c
>
> between commit:
>
>   7947d3e075cd ("mac80211: Add support for beacon report radio measurement")
>
> from the net-next tree and commit:
>
>   69e046423ad7 ("iwlwifi: mvm: change scan timeout to a delayed work")
>
> from the wireless-drivers-next tree.
>
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

Thanks. I'm planning to submit a pull request to Dave tomorrow and I'll
include instruction how to solve these mac80211 API conflicts.

-- 
Kalle Valo
