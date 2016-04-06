Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60220 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbcDFS2O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 14:28:14 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: fix Tx timeout issue during suspend test
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1458139576-4702-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160406182812.D29196031A@smtp.codeaurora.org> (sfid-20160406_202817_481028_76ED25D0)
Date: Wed,  6 Apr 2016 18:28:12 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Call netif_carrier_off/on while stoping/starting netdev queues.
> This fixes netdev watchdog warning and ->ndo_tx_timeout() invocation
> during suspend resume stress test.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Fixes: 54f008497b9f09f ('mwifiex: Empty Tx queue during suspend')
> Tested-by: Wei-Ning Huang <wnhuang@chromium.org>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
