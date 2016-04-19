Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42051 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933246AbcDSQOX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 12:14:23 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Colin King <colin.king@canonical.com>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k: remove duplicate assignment of variable ah
References: <1460287531-17385-1-git-send-email-colin.king@canonical.com>
Date: Tue, 19 Apr 2016 19:14:18 +0300
In-Reply-To: <1460287531-17385-1-git-send-email-colin.king@canonical.com>
	(Colin King's message of "Sun, 10 Apr 2016 12:25:31 +0100")
Message-ID: <87ega1inj9.fsf@kamboji.qca.qualcomm.com> (sfid-20160419_181444_447704_C3198DBD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin King <colin.king@canonical.com> writes:

> From: Colin Ian King <colin.king@canonical.com>
>
> ah is written twice with the same value, remove one of the
> redundant assignments to ah.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied, thanks.

-- 
Kalle Valo
