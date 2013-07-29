Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52612 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab3G2SpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jul 2013 14:45:12 -0400
Date: Mon, 29 Jul 2013 14:42:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qca.qualcomm.com,
	ath10k@lists.infradead.org
Subject: Re: Pull request: ath-current 20130723
Message-ID: <20130729184203.GD31172@tuxdriver.com> (sfid-20130729_204531_031507_41C6293A)
References: <87ehapwqum.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87ehapwqum.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 23, 2013 at 12:46:57PM +0300, Kalle Valo wrote:
> Hi John,
> 
> here's an ath6kl and ath10k pull request for 3.11-rc series.
> 
> Geert Uytterhoeven fixed an ath10k build problem when NO_DMA=y. I added
> a missing MAINTAINERS entry for ath10k and updated ath6kl git tree
> location.
> 
> Please let me know if there are any problems, or if you prefer me to
> send them through wireless-next instead.
> 
> Kalle
> 
> The following changes since commit 64b6f46f1141ad938e354f37af62e28da972e8eb:
> 
>   ath9k_hw: Fix multicast search for AR9002 family (2013-07-18 16:22:00 -0400)
> 
> are available in the git repository at:
> 
>   git://github.com/kvalo/ath.git for-linville-current
> 
> for you to fetch changes up to 58cfb681bffb43654776a218a087028ff425ba9e:
> 
>   MAINTAINERS: update ath6kl git location (2013-07-22 12:26:12 +0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
