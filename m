Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27218 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3LKF6n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Dec 2013 00:58:43 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix WEP Shared authentication
References: <1386222821-3062-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 11 Dec 2013 07:58:37 +0200
In-Reply-To: <1386222821-3062-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 5 Dec 2013 06:53:41 +0100")
Message-ID: <87fvq0rks2.fsf@kamboji.qca.qualcomm.com> (sfid-20131211_065846_650042_448793F0)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Frames received from FW were treated incorrectly.
> This led to stations being unable to associate to
> WEP Shared ath10k AP. This was indicated by a
> bizarre hostapd message:
>
>   Unsupported authentication algorithm (36088)
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
