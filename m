Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:53312 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaLXP3N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2014 10:29:13 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Peter Oh <poh@qca.qualcomm.com>
Cc: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath: fix incorrect PPB on FCC radar type 5
References: <1418669734-12921-1-git-send-email-poh@qca.qualcomm.com>
Date: Wed, 24 Dec 2014 17:29:07 +0200
In-Reply-To: <1418669734-12921-1-git-send-email-poh@qca.qualcomm.com> (Peter
	Oh's message of "Mon, 15 Dec 2014 10:55:34 -0800")
Message-ID: <87sig583ss.fsf@kamboji.qca.qualcomm.com> (sfid-20141224_162916_774493_95827E62)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@qca.qualcomm.com> writes:

> The minimum number of pulses per burst on FCC radar type 5 is 1.
> Use this number for correct radar detection.
>
> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>

Thanks, applied to wireless-drivers-next.git.

-- 
Kalle Valo
