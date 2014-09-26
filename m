Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40150 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042AbaIZRpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2014 13:45:11 -0400
Date: Fri, 26 Sep 2014 13:36:33 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: Pull request: ath 20140923
Message-ID: <20140926173633.GF22967@tuxdriver.com> (sfid-20140926_194539_879115_546AF554)
References: <8738big00t.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8738big00t.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 23, 2014 at 12:26:58PM +0300, Kalle Valo wrote:
> Hi John,
> 
> a new pull request just with ath10k changes this time. Changelog below
> and please let me know if there are any problems.
> 
> ----------------------------------------------------------------------
> 
> The only new feature is testmode support from me. Ben added a new method
> to crash the firmware with an assert for debug purposes. As usual, we
> have lots of smaller fixes from Michal. Matteo fixed a Kconfig
> dependency with debugfs. I fixed some warnings recently added to
> checkpatch.
> 
> ----------------------------------------------------------------------
> 
> 
> The following changes since commit 6a5d088a923854569e20eac4f3f569926d5911ec:
> 
>   carl9170: tx: Replace rcu_assign_pointer() with RCU_INIT_POINTER() (2014-08-28 14:50:13 -0400)
> 
> are available in the git repository at:
> 
>   git://github.com/kvalo/ath.git for-linville
> 
> for you to fetch changes up to b25f32cb02155d68c690255ba846796a1c248fd3:
> 
>   ath10k: use ether_addr_copy() (2014-09-18 10:47:03 +0300)

Pulling now, but I don't plan to push it back out until Dave pulls my earlier batch...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
