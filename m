Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41329 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbcCUK3I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2016 06:29:08 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Wei-Ning Huang <wnhuang@chromium.org>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, akarwar@marvell.com,
	djkurtz@chromium.org, nishants@marvell.com, netdev@vger.kernel.org
Subject: Re: [PATCH] mwifiex: advertise low priority scan feature
References: <1458547622-1632-1-git-send-email-wnhuang@google.com>
Date: Mon, 21 Mar 2016 12:28:59 +0200
In-Reply-To: <1458547622-1632-1-git-send-email-wnhuang@google.com> (Wei-Ning
	Huang's message of "Mon, 21 Mar 2016 16:07:02 +0800")
Message-ID: <87d1qogm50.fsf@kamboji.qca.qualcomm.com> (sfid-20160321_112937_696760_5D68D653)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wei-Ning Huang <wnhuang@chromium.org> writes:

> From: Amitkumar Karwar <akarwar@marvell.com>
>
> Low priority scan handling code which delays or aborts scan
> operation based on Tx traffic is removed recently. The reason
> is firmware already takes care of it in our new feature scan
> channel gap. Hence we should advertise low priority scan
> support to cfg80211.
>
> This patch fixes a problem in which OBSS scan request from
> wpa_supplicant was being rejected by cfg80211.
>
> Signed-off-by: Wei-Ning Huang <wnhuang@chromium.org>

The From line states that this is written by Amitkumar but there's no
Signed-off-By line from him. I can't take this without that, please
resend.

(Wei-Ning's s-o-b line is correct, I just need also Amitkumar's line.)

-- 
Kalle Valo
