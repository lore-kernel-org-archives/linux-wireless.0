Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49227 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506Ab3HOUAS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Aug 2013 16:00:18 -0400
Date: Thu, 15 Aug 2013 15:54:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qca.qualcomm.com,
	ath10k@lists.infradead.org
Subject: Re: Pull request: ath 20130812
Message-ID: <20130815195435.GF2133@tuxdriver.com> (sfid-20130815_220023_898280_D060A6DA)
References: <871u5zuhbm.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <871u5zuhbm.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 12, 2013 at 05:14:37PM +0300, Kalle Valo wrote:
> Hi John,
> 
> here's a small pull request for ath10k and ath6kl. The changes are:
> 
> New features in ath10k are rx/tx checsumming in hw and survey scan
> implemented by Michal. Also he made fixes to different areas of the
> driver, most notable being fixing the case when using two streams and
> reducing the number of interface combinations to avoid firmware crashes.
> Bartosz did a clean related to how we handle SoC power save in PCI
> layer.
> 
> For ath6kl Mohammed and Vasanth sent each a patch to fix two infrequent
> crashes.
> 
> The following changes since commit 424121c365aed6ec93bbc8b515548df79c5af61c:
> 
>   ath10k: fix rts/fragmentation threshold setup (2013-07-30 18:01:21 +0300)
> 
> are available in the git repository at:
> 
>   git://github.com/kvalo/ath.git for-linville
> 
> for you to fetch changes up to 9d0e2f0772d394060bf3b17cd1f3a35574365103:
> 
>   ath6kl: Fix invalid pointer access on fuzz testing with AP mode (2013-08-07 10:58:59 +0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
