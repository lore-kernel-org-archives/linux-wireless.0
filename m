Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60709 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbbGUN5x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 09:57:53 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: fix for p2p broken link
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1435842422-15608-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Aniket Nagarnaik <aniketn@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20150721135753.569341413B1@smtp.codeaurora.org> (sfid-20150721_155757_887463_BD5A3583)
Date: Tue, 21 Jul 2015 13:57:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Aniket Nagarnaik <aniketn@marvell.com>
> 
> This patch fixes following issues in p2p code paths.
> 
> 1) bss role, bss type and connection type was not set correctly
> for p2p GO and p2p client at couple of places.
> 2) Driver appends a proprietary header to management frames
> which will be parsed by our firmware. Later while informing
> TX status to cfg80211, modified frame buffer was passed to
> cfg80211_mgmt_tx_status() instead of original one.
> 
> Signed-off-by: Aniket Nagarnaik <aniketn@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
