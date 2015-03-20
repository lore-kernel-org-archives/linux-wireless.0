Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53021 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbbCTHHw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 03:07:52 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: fix crash in SDIO RX path
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1426689772-24302-1-git-send-email-patila@marvell.com>
To: Avinash Patil <patila@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <liuzy@marvell.com>,
	Avinash Patil <patila@marvell.com>
Message-Id: <20150320070752.1EE33140E31@smtp.codeaurora.org> (sfid-20150320_080755_731465_B8DF1D7C)
Date: Fri, 20 Mar 2015 07:07:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> With patch '960d6d08e39 "mwifiex: delay skb allocation for RX
> until cmd53 over"' we no more pass skb parameter to MP aggregation setup
> helper function. We instead pass length to be aggregated.
> 
> This patch fixes an issue where we were passing length parameter of NULL
> skb to aggregation routine resulting into crash. We should instead pass
> rx_len received from mp_regs.
> 
> Signed-off-by: Avinash Patil <patila@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
