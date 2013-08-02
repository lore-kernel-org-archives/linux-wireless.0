Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59176 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629Ab3HBTpS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Aug 2013 15:45:18 -0400
Date: Fri, 2 Aug 2013 15:40:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: Pull request: ath 20130730
Message-ID: <20130802194034.GE10800@tuxdriver.com> (sfid-20130802_214524_958831_675B6B80)
References: <87txjct6pf.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87txjct6pf.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 30, 2013 at 06:20:44PM +0300, Kalle Valo wrote:
> Hi John,
> 
> here's a new pull request containing just ath10k patches from Michal.
> 
> A major new feature is that we can now restart the firmware when it
> crashes. For this Michal needed quite a few preparation patches. It's
> now possible to to crash the firmware from debugfs, which makes it
> easier to test the restart feature.
> 
> Michal also sent fixes and cleanup to various parts in the driver. Most
> visible to users are RTS and fragmentation related fixes.
> 
> Please pull and do let me know if there are any problems.
> 
> Kalle
> 
> The following changes since commit 2cdf359a521bb72286b6714478dfdbcd2691f3fe:
> 
>   mwifiex: code rearrangement in sdio.c (2013-07-26 16:57:45 -0400)
> 
> are available in the git repository at:
> 
>   git://github.com/kvalo/ath6kl.git tags/for-linville-20130730
> 
> for you to fetch changes up to 424121c365aed6ec93bbc8b515548df79c5af61c:
> 
>   ath10k: fix rts/fragmentation threshold setup (2013-07-30 18:01:21 +0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
