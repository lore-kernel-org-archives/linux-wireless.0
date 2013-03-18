Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34769 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab3CRUpe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 16:45:34 -0400
Date: Mon, 18 Mar 2013 16:35:47 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: Pull request: ath6kl 20130318
Message-ID: <20130318203547.GA2638@tuxdriver.com> (sfid-20130318_214538_345517_24A05E49)
References: <87obeg7tpl.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87obeg7tpl.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 18, 2013 at 02:55:50PM +0200, Kalle Valo wrote:
> Hi John,
> 
> here's an ath6kl pull request for 3.10. Please let me know if there are
> any problems.
> 
> I added tracing support to ath6kl, along with a new Kconfig option. Now
> there's also a workaround to reset USB devices when the firmware upload
> fails, this happened when host was warm rebooted. There are also quite a
> few small fixes or cleanup.
> 
> The following changes since commit b53cf458ea20dd7f5e32611366f63728e40c9021:
> 
>   net: wireless: hostap: hostap_ap.c: Return -ENOMEM instead of -1 for if kmalloc() fails. (2013-02-18 15:30:40 -0500)
> 
> are available in the git repository at:
> 
>   git://github.com/kvalo/ath6kl.git tags/for-linville-20130318
> 
> for you to fetch changes up to 243c028099c467186d126859848bdac3bbfe8da0:
> 
>   ath6kl: Fix a debugfs crash for USB devices (2013-03-18 14:09:40 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
