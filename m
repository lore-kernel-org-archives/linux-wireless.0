Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51488 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaENTpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 15:45:14 -0400
Date: Wed, 14 May 2014 15:40:29 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: Pull request: ath 20140514
Message-ID: <20140514194029.GE14183@tuxdriver.com> (sfid-20140514_214520_540080_B9C7F88F)
References: <87zjikfqus.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87zjikfqus.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Were you hoping for 3.15 for these?

On Wed, May 14, 2014 at 04:10:35PM +0300, Kalle Valo wrote:
> Hi John,
> 
> small pull request this time. I'll promise next one will be bigger ;)
> 
> Changelog for the request:
> 
> For ath10k Michal did various small fixes on how we handle
> hardware/firmware problems and he also fixed two memory leaks.
> 
> Please let me know if there are any problems.
> 
> The following changes since commit 644aa4d62096039a79987e13062c6fc656ea380c:
> 
>   b43: remove list of IEEE 802.11 devices (2014-04-22 15:06:34 -0400)
> 
> are available in the git repository at:
> 
>   git://github.com/kvalo/ath.git for-linville
> 
> for you to fetch changes up to d9bc4b9b693d52dc14dc1de5dfec760634067d8c:
> 
>   ath10k: fix firmware recovery with ap interface (2014-04-24 09:23:03 +0300)
> 
> ----------------------------------------------------------------
> Michal Kazior (7):
>       ath10k: differentiate between target init failures
>       ath10k: don't wait for device init if it crashed
>       ath10k: skip suspending when recovering
>       ath10k: make sure to not leak beacon dma mapping
>       ath10k: make sure to not use invalid beacon pointer
>       ath10k: prevent beacon memory leak
>       ath10k: fix firmware recovery with ap interface
> 
>  drivers/net/wireless/ath/ath10k/core.c |    6 ++++--
>  drivers/net/wireless/ath/ath10k/mac.c  |   16 ++++++++++++++++
>  drivers/net/wireless/ath/ath10k/pci.c  |   18 +++++++++++++++++-
>  drivers/net/wireless/ath/ath10k/wmi.c  |    2 ++
>  4 files changed, 39 insertions(+), 3 deletions(-)
> 
> -- 
> Kalle Valo
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
