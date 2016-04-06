Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59668 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbcDFSVW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 14:21:22 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: miaoqing@codeaurora.org
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@qca.qualcomm.com
Subject: Re: [PATCH] ath9k: fix rng high cpu load
References: <1458294896-7502-1-git-send-email-miaoqing@codeaurora.org>
Date: Wed, 06 Apr 2016 21:21:17 +0300
In-Reply-To: <1458294896-7502-1-git-send-email-miaoqing@codeaurora.org>
	(miaoqing@codeaurora.org's message of "Fri, 18 Mar 2016 17:54:56
	+0800")
Message-ID: <87mvp68uoy.fsf@kamboji.qca.qualcomm.com> (sfid-20160406_202126_018122_0CAB7F20)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

miaoqing@codeaurora.org writes:

> From: Miaoqing Pan <miaoqing@codeaurora.org>
>
> If no valid ADC randomness output, ath9k rng will continuously
> reading ADC, which will cause high CPU load. So increase the
> delay to wait for ADC ready.
>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=114261
> Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>

Applied, thanks.

-- 
Kalle Valo
