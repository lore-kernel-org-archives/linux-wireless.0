Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42074 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906Ab3JRSAg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Oct 2013 14:00:36 -0400
Date: Fri, 18 Oct 2013 13:57:33 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	ath6kl-devel@qca.qualcomm.com
Subject: Re: Pull request: ath 20131017
Message-ID: <20131018175732.GD28130@tuxdriver.com> (sfid-20131018_200039_644287_C9078E3B)
References: <87mwm82rmu.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87mwm82rmu.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 17, 2013 at 12:06:33PM +0300, Kalle Valo wrote:
> Hi John,
> 
> here's a pull request for ath6kl and ath10k. Notable changes:
> 
> Bartosz added support to ath10k for our 10.x AP firmware branch, which
> gives us AP specific features and fixes. We still support the main
> firmware branch as well just like before, ath10k detects runtime what
> firmware is used. Unfortunately the firmware interface in 10.x branch is
> somewhat different so there was quite a lot of changes in ath10k for
> this.
> 
> Michal and Sujith did some performance improvements in ath10k. Vladimir
> fixed a compiler warning and Fengguang removed an extra semicolon.
> 
> Please let me know if there are any problems.
> 
> Kalle
> 
> The following changes since commit 6e712d427cb0542afdd5220edb6e4f4f8a5b952d:
> 
>   ath10k: replenish HTT RX buffers in a tasklet (2013-09-26 17:22:54 +0300)
> 
> are available in the git repository at:
> 
>   git://github.com/kvalo/ath.git for-linville
> 
> for you to fetch changes up to 56b84287d14aa74823a9c290d0c5839d38365110:
> 
>   ath10k: add might_sleep() to ath10k_wmi_cmd_send() (2013-10-16 15:44:47 +0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
