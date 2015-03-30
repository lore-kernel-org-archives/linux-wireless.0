Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58027 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbbC3Igu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 04:36:50 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/2] mwifiex: stop command path in suspend handler
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1427120456-6247-1-git-send-email-patila@marvell.com>
To: Avinash Patil <patila@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <liuzy@marvell.com>,
	Avinash Patil <patila@marvell.com>
Message-Id: <20150330083649.70EB0140299@smtp.codeaurora.org> (sfid-20150330_103653_282405_07C453C4)
Date: Mon, 30 Mar 2015 08:36:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Cancel all pending commands including scan commands and stop CAC
> during cfg80211 suspend handler.
> 
> Signed-off-by: Avinash Patil <patila@marvell.com>

Thanks, 2 patches applied to wireless-drivers-next.git:

5ff46f7923b8 mwifiex: stop command path in suspend handler
4acaf048b1d2 mwifiex: recover from skb allocation failures during RX

Kalle Valo
