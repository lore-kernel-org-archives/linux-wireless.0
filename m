Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44682 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbcCJM7a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 07:59:30 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2] mwifiex: Empty Tx queue during suspend
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1457526071-30658-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <wnhuang@google.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160310125929.F0FEA60EC4@smtp.codeaurora.org> (sfid-20160310_135945_130228_1C70843D)
Date: Thu, 10 Mar 2016 12:59:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> In cfg80211 suspend handler, stop the netif queue and
> wait until all the Tx queues become empty. Start the
> queues in resume handler.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
