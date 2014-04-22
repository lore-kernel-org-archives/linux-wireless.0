Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50881 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757565AbaDVUPt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 16:15:49 -0400
Date: Tue, 22 Apr 2014 16:06:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath6kl@lists.infradead.org,
	ath10k@lists.infradead.org
Subject: Re: Pull request: ath 20140415
Message-ID: <20140422200658.GD16193@tuxdriver.com> (sfid-20140422_221645_741467_436CB21A)
References: <87mwfndrt4.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87mwfndrt4.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 15, 2014 at 09:34:31AM +0300, Kalle Valo wrote:
> Hi John,
> 
> here's a pull request for ath6kl and ath10k with changes accumulated
> just before and during the merge window. Please let me know if there any
> problems.
> 
> Here's the list of changes:
> 
> ----------------------------------------------------------------------
> 
> For ath6kl Kalle fixed a bunch of checkpatch warnings.
> 
> In ath10k we had more changes, major ones being:
> 
> * fix memory allocation failures after a firmware crash (Michal)
> 
> * some rework of DFS configuration to enable it correctly in all cases
>   (Michal)
> 
> * add a new firmware crash option to make it possible to crash 10.1
>   firmware for testing purposes (Marek P)
> 
> * fix RTS/CTS protection in certain cases (Marek K)
> 
> * fix wrong RSSI and rate reporting in some cases (Janusz)
> 
> * fix firmware stats reporting (Chun, Ben & Bartosz)
> 
> ----------------------------------------------------------------------
> 
> The following changes since commit 70dd77b4c50da518b57b8b9b125a8c9aabe9bc1a:
> 
>   ath10k: do not overwrite max_antenna_gain (2014-03-07 10:14:10 +0200)
> 
> are available in the git repository at:
> 
>   git://github.com/kvalo/ath.git for-linville
> 
> for you to fetch changes up to 4bfee8e8c13fc9477eb9420efd5a5d12e32ac614:
> 
>   ath10k: improve htc tx credit debugging prints (2014-04-11 08:35:56 +0300)

Pulled today...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
