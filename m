Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37509 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933486AbbJIIrV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2015 04:47:21 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Colin King <colin.king@canonical.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath6kl: remove redundant null pointer check on send_pkt
References: <1441633745-5755-1-git-send-email-colin.king@canonical.com>
Date: Fri, 09 Oct 2015 11:47:14 +0300
In-Reply-To: <1441633745-5755-1-git-send-email-colin.king@canonical.com>
	(Colin King's message of "Mon, 7 Sep 2015 14:49:05 +0100")
Message-ID: <874mi0sa25.fsf@kamboji.qca.qualcomm.com> (sfid-20151009_104752_109133_AA9EBEDA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin King <colin.king@canonical.com> writes:

> From: Colin Ian King <colin.king@canonical.com>
>
> The check for send_pkt being NULL is redundant before the call
> to htc_reclaim_txctrl_buf, therefore it should be removed. This was
> detected by static analysis by cppcheck.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied, thanks.

-- 
Kalle Valo
