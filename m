Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50512 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbcCGM1Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 07:27:16 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/4] mwifiex: add delay when tdls confirm frame is queued
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1456233379-12099-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160307122715.462AB60897@smtp.codeaurora.org> (sfid-20160307_132720_296383_8569BEC6)
Date: Mon,  7 Mar 2016 12:27:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Xinming Hu <huxm@marvell.com>
> 
> It is observed that driver may send the data packet to tdls peer
> before tdls peer receives tdls setup confirm frame.
> Similar race condition exists during tdls teardown procedure also.
> This patch adds 10 milliseconds delay to resolve the race.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 4 patches applied to wireless-drivers-next.git:

de651ce3d750 mwifiex: add delay when tdls confirm frame is queued
a6139b6271f9 mwifiex: fix corner case association failure
8b7ef8b66eb9 mwifiex: add sdio multiport aggregation debug information
0cb52aac4d19 mwifiex: do not set multiport flag for tx/rx single packet

Kalle Valo
