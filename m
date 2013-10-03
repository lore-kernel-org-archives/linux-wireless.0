Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39298 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab3JCUaR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Oct 2013 16:30:17 -0400
Date: Thu, 3 Oct 2013 16:17:06 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qca.qualcomm.com,
	ath10k@lists.infradead.org
Subject: Re: Pull request: ath 20131001
Message-ID: <20131003201706.GE3142@tuxdriver.com> (sfid-20131003_223025_029362_29A94F0D)
References: <87wqlw6fwr.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87wqlw6fwr.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 01, 2013 at 08:48:36PM +0300, Kalle Valo wrote:
> Hi John,
> 
> here's a bigger pull request including patches applied during the merge
> window. Major changes are:
> 
> * throughput improvements including aligning the RX frames correctly and
>   optimising HTT layer (Michal)
> 
> * remove qca98xx hw1.0 support (Bartosz)
> 
> * add support for firmware version 999.999.0.636 (Michal)
> 
> * firmware htt statistics support (Kalle)
> 
> * fix WEP in AP and IBSS mode (Marek)
> 
> * fix a mutex unlock balance in debugfs file (Shafi)
> 
> And of course there's a lot of smaller fixes and cleanup.
> 
> To avoid the pull request getting too big, I didn't include the latest
> patches from ath.git. I'm planning to send them once you have pulled
> this one. Please let me know if there are any problems.
> 
> Kalle
> 
> 
> The following changes since commit 9d0e2f0772d394060bf3b17cd1f3a35574365103:
> 
>   ath6kl: Fix invalid pointer access on fuzz testing with AP mode (2013-08-07 10:58:59 +0300)
> 
> are available in the git repository at:
> 
>   git://github.com/kvalo/ath.git tags/for-linville-20131001
> 
> for you to fetch changes up to 6e712d427cb0542afdd5220edb6e4f4f8a5b952d:
> 
>   ath10k: replenish HTT RX buffers in a tasklet (2013-09-26 17:22:54 +0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
