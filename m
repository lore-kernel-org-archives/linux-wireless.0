Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60688 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931AbbHJTPq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 15:15:46 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: correct TDLS link delete failure message priority
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1438093340-20392-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20150810191545.8E5FB14114A@smtp.codeaurora.org> (sfid-20150810_211549_221931_447E873A)
Date: Mon, 10 Aug 2015 19:15:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Commit d8d2f19feb16 ("mwifiex: silence TDLS link delete failure
> for nonexistent link") lowers the priority of error message when
> TDLS link is already deleted. But it had got increased by
> commit acebe8c10a6e ("mwifiex: change dbg print func to
> mwifiex_dbg")
> 
> Reported-by: Nicholas Mc Guire <der.herr@hofr.at>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
