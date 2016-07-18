Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40728 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbcGRTmd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 15:42:33 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: Fix request_irq() failure handling
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1468586919-7534-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Karthik D A <karthida@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160718194233.142B7602A9@smtp.codeaurora.org> (sfid-20160718_214249_704473_9EF5EC05)
Date: Mon, 18 Jul 2016 19:42:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> From: Karthik D A <karthida@marvell.com>
> 
> It's been observed that request_irq() failure leads to a system crash
> due to a bug in mwifiex driver.
> When this failure happens, mwifiex_add_card() already takes care of
> clearing and freeing adapter->card pointer. This patch removes the
> redundant cleanup code causing crash.
> 
> Signed-off-by: Karthik D A <karthida@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

2af86f9d954e mwifiex: Fix request_irq() failure handling

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9231905/

