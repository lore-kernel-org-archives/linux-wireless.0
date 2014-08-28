Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46796 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbaH1SpV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 14:45:21 -0400
Date: Thu, 28 Aug 2014 14:37:06 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath6kl@lists.infradead.org,
	ath10k@lists.infradead.org
Subject: Re: Pull request: ath 20140827
Message-ID: <20140828183706.GN13758@tuxdriver.com> (sfid-20140828_204536_825424_F3CFEFE5)
References: <87egw2w01r.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87egw2w01r.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 27, 2014 at 04:10:24PM +0300, Kalle Valo wrote:
> Hi John,
> 
> here's a new pull request containing latest ath10k and ath6kl patches
> accumulated during the merge window, changelog below. Please let me know
> if there are any problems.
> 
> Please note that commit 7aa7a72a2367 ("ath10k: improve logging to
> include dev id") is huge but still a simple patch adding 'ar' variable
> to every logging function we have.
> 
> Also note that 95752b759e2e ("ath: Move spectral debugfs structs to
> shared header") moves code from ath9k to the generic ath.ko module.
> 
> ----------------------------------------------------------------------
> For ath6kl we had two small fixes and a new SDIO device id.
> 
> For ath10k the bigger changes are:
> 
>  * support for new firmware version 10.2 (Michal)
> 
>  * spectral scan support (Simon, Sven & Mathias)
> 
>  * export a firmware crash dump file (Ben & me)
> 
>  * cleaning up of pci.c (Michal)
> 
>  * print pci id in all messages, which causes most of the churn (Michal)
> 
> ----------------------------------------------------------------------
> 
> The following changes since commit 0ccb7a3485e5526dca69f036b0d6c5148c78b3f8:
> 
>   ath10k: handle attention flags correctly when using A-MSDU (2014-07-25 11:51:07 +0300)
> 
> are available in the git repository at:
> 
>   git://github.com/kvalo/ath.git for-linville
> 
> for you to fetch changes up to 0fdc14e42b40ecd7115cc670981d39a89eeee6c3:
> 
>   ath10k: make target endianess more explicit (2014-08-27 15:03:32 +0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
