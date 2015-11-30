Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37102 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbbK3MqT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2015 07:46:19 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: "Yin\, Fengwei" <fengwei.yin@linaro.org>
Cc: andy.green@linaro.org, linux-wireless@vger.kernel.org,
	wcn36xx@lists.infradead.org, me@bobcopeland.com,
	k.eugene.e@gmail.com, bjorn.andersson@sonymobile.com
Subject: Re: [PATCH v2 4/5] wcn3620: use new response format for wcn3620 trigger_ba
References: <1447143955-10304-1-git-send-email-fengwei.yin@linaro.org>
	<1447143955-10304-5-git-send-email-fengwei.yin@linaro.org>
Date: Mon, 30 Nov 2015 14:46:14 +0200
In-Reply-To: <1447143955-10304-5-git-send-email-fengwei.yin@linaro.org>
	(Fengwei Yin's message of "Tue, 10 Nov 2015 03:25:54 -0500")
Message-ID: <87bnabk63t.fsf@kamboji.qca.qualcomm.com> (sfid-20151130_134623_031431_5A0F5DBA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Yin, Fengwei" <fengwei.yin@linaro.org> writes:

> From: Andy Green <andy.green@linaro.org>
>
> On wcn3620, firmware response to trigger_ba uses the new, larger
> "v2" format
>
> Signed-off-by: Andy Green <andy.green@linaro.org>

Please prefix the patch title with the name of driver, in this case that
would be "wcn36xx: ". This time I fixed it before I applied the patches.

-- 
Kalle Valo
