Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46474 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbbFHIuy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 04:50:54 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/2] mwifiex: change debug dump issue since skb maybe null
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1433446314-13098-1-git-send-email-patila@marvell.com>
To: Avinash Patil <patila@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <huxm@marvell.com>, <liuzy@marvell.com>,
	Avinash Patil <patila@marvell.com>
Message-Id: <20150608085053.67AF5140814@smtp.codeaurora.org> (sfid-20150608_105057_005651_7F876F14)
Date: Mon,  8 Jun 2015 08:50:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Zhaoyang Liu <liuzy@marvell.com>
> 
> This patch fixes semantic warning for debugging data dump feature.
> Previous code is based on the assumption that skb is not null.
> New change makes sure that we already have data buffer.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
> Signed-off-by: Avinash Patil <patila@marvell.com>

Thanks, 2 patches applied to wireless-drivers-next.git:

7a56c4168e44 mwifiex: change debug dump issue since skb maybe null
39d94eaa76e7 mwifiex: update current config_band info in start_ap

Kalle Valo
