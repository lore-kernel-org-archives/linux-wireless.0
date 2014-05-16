Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55125 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626AbaEPSaQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2014 14:30:16 -0400
Date: Fri, 16 May 2014 14:15:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: Pull request: ath 20140514
Message-ID: <20140516181545.GG3431@tuxdriver.com> (sfid-20140516_203020_950085_A2C1CD6C)
References: <87zjikfqus.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87zjikfqus.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
