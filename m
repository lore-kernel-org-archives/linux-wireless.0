Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39989 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbcHOH4t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2016 03:56:49 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Maxim Altshul <maxim.altshul@ti.com>
Cc: <linux-kernel@vger.kernel.org>, <john.stultz@linaro.org>,
	Eliad Peller <eliad@wizery.com>,
	Yaniv Machani <yanivma@ti.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] wlcore: Remove wl pointer from wl_sta structure
References: <20160804124314.7636-1-maxim.altshul@ti.com>
	<20160804124314.7636-2-maxim.altshul@ti.com>
	<20160804124314.7636-3-maxim.altshul@ti.com>
Date: Mon, 15 Aug 2016 10:56:43 +0300
In-Reply-To: <20160804124314.7636-3-maxim.altshul@ti.com> (Maxim Altshul's
	message of "Thu, 4 Aug 2016 15:43:05 +0300")
Message-ID: <87bn0uea84.fsf@kamboji.qca.qualcomm.com> (sfid-20160815_095711_103353_4F4DA53F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maxim Altshul <maxim.altshul@ti.com> writes:

> No longer needed due to get_expected_throughput op change
>
> Signed-off-by: Maxim Altshul <maxim.altshul@ti.com>

The commit log is very vague, please improve it. But most importantly
you did not CC linux-wireless (adding it now) so lots of wireless people
missed this patch. Please resend.

-- 
Kalle Valo
