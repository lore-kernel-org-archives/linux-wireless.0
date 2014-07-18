Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50553 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761707AbaGRSAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2014 14:00:16 -0400
Date: Fri, 18 Jul 2014 13:45:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	ath6kl@lists.infradead.org
Subject: Re: Pull request: ath 20140717
Message-ID: <20140718174515.GF31114@tuxdriver.com> (sfid-20140718_200023_771220_4623842A)
References: <87k37c6kw6.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87k37c6kw6.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 17, 2014 at 06:54:33PM +0300, Kalle Valo wrote:
> Hi John,
> 
> here's new pull request for 3.17. Major changes are:
> 
> For ath6kl me and Jessica added support for ar6004 hw3.0, our latest
> version of ar6004.
> 
> For ath10k Janusz added a printout so that it's easier to check what
> ath10k kconfig options are enabled. He also added a debugfs file to
> configure maximum amsdu and ampdu values. Also we had few fixes as
> usual.
> 
> Please let me know if there are any problems.
> 
> Kalle
> 
> The following changes since commit a715c7ddd65a1a3b2839b8ebd759bb2d361f7675:
> 
>   wil6210: improve debug for WMI receive (2014-05-30 13:49:34 -0400)
> 
> are available in the git repository at:
> 
>   git://github.com/kvalo/ath.git tags/for-linville-20140717
> 
> for you to fetch changes up to 993619443774f7ef4df3b98655df4c3bf298548c:
> 
>   ath10k: sanitize tx ring index access properly (2014-07-15 11:19:45 +0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
