Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42570 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab3BOTPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 14:15:11 -0500
Date: Fri, 15 Feb 2013 14:07:56 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qca.qualcomm.com
Subject: Re: Pull request: ath6kl 20130215
Message-ID: <20130215190756.GD4981@tuxdriver.com> (sfid-20130215_201517_000787_3049E79E)
References: <87liap68rn.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87liap68rn.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 15, 2013 at 02:50:36PM +0200, Kalle Valo wrote:
> Hi John,
> 
> here's a small pull request for ath6kl. I don't know if there's enough
> time for 3.9, but I'll try my luck.
> 
> There's not anything special here, most of the patches are just code
> cleanup. The only functional changes are using the beacon interval from user
> space and fixing a crash which happens when inserting and removing the
> module in a loop.
> 
> Please let me know if there are any problems.
> 
> The following changes since commit ff7e68670c49b6404acc4fce6ca90d6c89ef0efe:
> 
>   ath6kl: support NL80211_USER_REG_HINT_CELL_BASE events (2012-11-16 10:39:01 +0200)
> 
> are available in the git repository at:
> 
>   git://github.com/kvalo/ath6kl.git for-linville
> 
> for you to fetch changes up to 6f7c1adb7529935df6e288a1436003c1f6dc0653:
> 
>   ath6kl: minor optimization using if, else if (2012-11-27 21:44:28 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
