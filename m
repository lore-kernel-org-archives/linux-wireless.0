Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46859 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112AbaLAVAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 16:00:13 -0500
Date: Mon, 1 Dec 2014 15:51:50 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: Pull request: ath 20141201
Message-ID: <20141201205150.GC7266@tuxdriver.com> (sfid-20141201_220038_314420_C054165A)
References: <871tojr16m.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <871tojr16m.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 01, 2014 at 02:42:41PM +0200, Kalle Valo wrote:
> Hi John,
> 
> here's a pull request I'm hoping still to get to 3.19. The changelog is
> below. Please let me know if you have any problems.
> 
> ----------------------------------------------------------------------
> Only ath10k changes this time and no major changes. Most visible are:
> 
> o new debugfs interface for runtime firmware debugging (Yanbo)
> 
> o fix shared WEP (Sujith)
> 
> o don't rebuild whenever kernel version changes (Johannes)
> 
> o lots of refactoring to make it easier to add new hw support (Michal)
> 
> There's also smaller fixes and improvements with no point of listing
> here.
> 
> ----------------------------------------------------------------------
> 
> 
> The following changes since commit 47b6308b643302e642ca2a5cb6470926f7e1c428:
> 
>   ath9k: Move roc completion to the offchannel timer (2014-11-17 15:32:17 -0500)
> 
> are available in the git repository at:
> 
>   git://github.com/kvalo/ath.git for-linville
> 
> for you to fetch changes up to fe2407a889f7b6530b7e231e7c866f5c5d223657:
> 
>   ath10k: simplify rx ring size/fill calculation (2014-12-01 09:29:27 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
