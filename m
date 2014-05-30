Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36664 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaE3SAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 14:00:12 -0400
Date: Fri, 30 May 2014 13:44:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: Pull request: ath 20140530
Message-ID: <20140530174417.GG24054@tuxdriver.com> (sfid-20140530_200017_146461_8986EE52)
References: <87vbsn4q5d.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87vbsn4q5d.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 30, 2014 at 11:38:54AM +0300, Kalle Valo wrote:
> Hi John,
> 
> here's a new pull request for ath10k and also a small change for ath9k.
> I'm hoping to get these still to 3.16. The changelog is:
> 
> ----------------------------------------------------------------------
> Ben added support for setting antenna configurations. Michal improved
> warm reset so that we would not need to fall back to cold reset that
> often, an issue where ath10k stripped protected flag while in monitor
> mode and made module initialisation asynchronous to fix the problems
> with firmware loading when the driver is linked to the kernel.
> 
> Luca removed unused channel_switch_beacon callbacks both from ath9k and
> ath10k. Marek fixed Protected Management Frames (PMF) when using Action
> Frames. Also we had other small fixes everywhere in the driver.
> ----------------------------------------------------------------------
> 
> Please let me know if there are any problems.
> 
> Kalle
> 
> 
> The following changes since commit 5f407acbb7d6a92841c455b37a6ad4833757740e:
> 
>   rsi: Changed the return value to enable BA set-up (2014-05-13 15:56:53 -0400)
> 
> are available in the git repository at:
> 
>   git://github.com/kvalo/ath.git tags/for-linville-20140530
> 
> for you to fetch changes up to 08b8aa0931830cc4b96b47f884fe623aef5c4b84:
> 
>   ath10k: abort incomplete scatter-gather pci tx properly (2014-05-27 12:32:10 +0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
