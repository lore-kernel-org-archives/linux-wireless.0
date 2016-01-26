Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6472 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965184AbcAZPEE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 10:04:04 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Yanbo Li <yanbol@qca.qualcomm.com>
CC: <dreamfly281@gmail.com>, <linux-wireless@vger.kernel.org>,
	<ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: Remove the p2p notice of absence info from 10.2.4 FW beacon info
References: <1452814759-20377-1-git-send-email-yanbol@qca.qualcomm.com>
Date: Tue, 26 Jan 2016 17:03:50 +0200
In-Reply-To: <1452814759-20377-1-git-send-email-yanbol@qca.qualcomm.com>
	(Yanbo Li's message of "Thu, 14 Jan 2016 15:39:19 -0800")
Message-ID: <87lh7cpell.fsf@kamboji.qca.qualcomm.com> (sfid-20160126_160407_880542_B0820CBD)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yanbo Li <yanbol@qca.qualcomm.com> writes:

> The p2p NOA never been supported at 10.2.4 FW, remove it to avoid SWBA
> event parse error for multi beacon interval case.
>
> Signed-off-by: Yanbo Li <yanbol@qca.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo
