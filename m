Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57825 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbbC3IdZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 04:33:25 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: Fix issue in the SDIO reset path of mwifiex.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1427090485-29336-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20150330083324.CE9C6140207@smtp.codeaurora.org> (sfid-20150330_103328_522604_B64FF7BA)
Date: Mon, 30 Mar 2015 08:33:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Maithili Hinge <maithili@marvell.com>
> 
> SDIO reset was not happening properly on mwifiex as cancel_work_sync
> in mwifiex_sdio_remove used to kill the calling work function itself.
> Due to this, the interface was not getting removed and card was not
> getting added again. Reset work function has been made independent
> of adapter variable and cancel_work_sync has been moved to cleanup
> function.
> 
> Signed-off-by: Maithili Hinge <maithili@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
