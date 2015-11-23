Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38513 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbbKWPVA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 10:21:00 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Yanbo Li <yanbol@qca.qualcomm.com>
CC: <dreamfly281@gmail.com>, <linux-wireless@vger.kernel.org>,
	<ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: Adjust the RX packet pad offset at QCA99X0 4addr mode
References: <1445575816-4500-1-git-send-email-yanbol@qca.qualcomm.com>
Date: Mon, 23 Nov 2015 17:20:44 +0200
In-Reply-To: <1445575816-4500-1-git-send-email-yanbol@qca.qualcomm.com> (Yanbo
	Li's message of "Thu, 22 Oct 2015 21:50:16 -0700")
Message-ID: <87d1v0spwz.fsf@kamboji.qca.qualcomm.com> (sfid-20151123_162107_233245_88764461)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yanbo Li <yanbol@qca.qualcomm.com> writes:

> The QCA99X0 4 addresses RX packets pad 2 bytes at the beginning of
> MSDU instead the end of ieee80211 header to keep align. The currently
> RX data path can't parse the header correctly in this case. This
> patch fixes it for QCA99X0
>
> Signed-off-by: Yanbo Li <yanbol@qca.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo
