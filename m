Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36939 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbbK3MoL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2015 07:44:11 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2,1/5] wcn36xx: introduce WCN36XX_HAL_AVOID_FREQ_RANGE_IND
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1447143955-10304-2-git-send-email-fengwei.yin@linaro.org>
To: Fengwei Yin <fengwei.yin@linaro.org>
Cc: andy.green@linaro.org, linux-wireless@vger.kernel.org,
	wcn36xx@lists.infradead.org, me@bobcopeland.com,
	k.eugene.e@gmail.com, bjorn.andersson@sonymobile.com,
	fengwei.yin@linaro.org
Message-Id: <20151130124411.3175D14080A@smtp.codeaurora.org> (sfid-20151130_134415_549843_B524E333)
Date: Mon, 30 Nov 2015 12:44:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Andy Green <andy.green@linaro.org>
> 
> WCN3620 firmware introduces a new async indication, we need to
> add it as a known message type so we can accept it
> 
> Signed-off-by: Andy Green <andy.green@linaro.org>

Thanks, 5 patches applied to wireless-drivers-next.git:

9193adebc4d1 wcn36xx: introduce WCN36XX_HAL_AVOID_FREQ_RANGE_IND
df0d4364766f wcn36xx: swallow two wcn3620 IND messages
40ac77c8117b wcn36xx: handle new hal response format
69f66b688e93 wcn36xx: use new response format for wcn3620 trigger_ba
1d14c6f480f4 wcn36xx: use new response format for wcn3620 remove_bsskey

Kalle Valo
