Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48655 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbcAGJPp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 04:15:45 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/4] mwifiex: fix missing debug messages
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1451571855-29449-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160107091544.35438605BE@smtp.codeaurora.org> (sfid-20160107_101557_557703_FA5E35F1)
Date: Thu,  7 Jan 2016 09:15:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Xinming Hu <huxm@marvell.com>
> 
> Some critical messages are missed until "adapter->dev"
> gets initialized in mwifiex_register_dev().
> We will use pr_* print message instead of mwifiex_dbg at
> those places to resolve the problem.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 3 patches applied to wireless-drivers-next.git:

fdb1e28e05c9 mwifiex: fix missing debug messages
91442431c3f9 mwifiex: increase priority for critical message
ee548d4b1036 mwifiex: reduce cloned skb queue size

Kalle Valo
