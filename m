Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42382 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbbLaNM4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Dec 2015 08:12:56 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k_htc: fix handling return value of ath9k_hw_calibrate
References: <1450087564-28441-1-git-send-email-a.hajda@samsung.com>
	<1450087564-28441-4-git-send-email-a.hajda@samsung.com>
Date: Thu, 31 Dec 2015 15:12:46 +0200
In-Reply-To: <1450087564-28441-4-git-send-email-a.hajda@samsung.com> (Andrzej
	Hajda's message of "Mon, 14 Dec 2015 11:06:01 +0100")
Message-ID: <87ege2oj75.fsf@kamboji.qca.qualcomm.com> (sfid-20151231_141327_625425_238060E6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrzej Hajda <a.hajda@samsung.com> writes:

> The function can return negative values in case of error.
> Its result should be then tested for such case.
>
> The problem has been detected using proposed semantic patch
> scripts/coccinelle/tests/assign_signed_to_unsigned.cocci [1].
>
> [1]: http://permalink.gmane.org/gmane.linux.kernel/2046107
>
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>

Applied to ath.git, thanks.

-- 
Kalle Valo
