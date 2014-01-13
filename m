Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56350 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbaAMTpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 14:45:16 -0500
Date: Mon, 13 Jan 2014 14:40:24 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: Pull request: ath 20140113
Message-ID: <20140113194024.GD14400@tuxdriver.com> (sfid-20140113_204521_430488_C2A3695F)
References: <87fvos3xcz.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87fvos3xcz.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 13, 2014 at 02:00:28PM +0200, Kalle Valo wrote:
> Hi John,
> 
> here's another ath10k pull request. Major changes are:
> 
> Janusz added Kconfig option for DFS. The DFS code was there already, but
> after fixes to mac80211 we can now enable it.
> 
> Bartosz added a runtime firmware feature flag to disable P2P. Our 10.1
> firmware branch doesn't support P2P and ath10k can now disable that. He
> also added a limit for how many clients can connect to ath10k AP.
> 
> Michal fixed WEP shared authentication, in case someone still uses it.
> And I added firmware debug log to help the firmware engineers.
> 
> Please let me know if there any problems.
> 
> The following changes since commit 39731b78b4afebb7501c05b68e2443a1b250b41c:
> 
>   ath9k: simplify/fix tx packet TID handling (2013-12-19 14:41:57 -0500)
> 
> are available in the git repository at:
> 
>   git://github.com/kvalo/ath.git for-linville
> 
> for you to fetch changes up to 51ab1a0a09a894442e8b091d57222c5425b6d700:
> 
>   ath10k: add set_bitrate_mask callback (2014-01-10 11:54:49 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
