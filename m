Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40091 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbcHOH7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2016 03:59:14 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Maxim Altshul <maxim.altshul@ti.com>
Cc: <linux-kernel@vger.kernel.org>, <john.stultz@linaro.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Eliad Peller <eliad@wizery.com>,
	Yaniv Machani <yanivma@ti.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211/wlcore: Add ieee80211_hw variable to get_expected_throughput
References: <20160804124314.7636-1-maxim.altshul@ti.com>
	<20160804124314.7636-2-maxim.altshul@ti.com>
Date: Mon, 15 Aug 2016 10:59:07 +0300
In-Reply-To: <20160804124314.7636-2-maxim.altshul@ti.com> (Maxim Altshul's
	message of "Thu, 4 Aug 2016 15:43:04 +0300")
Message-ID: <8760r2ea44.fsf@kamboji.qca.qualcomm.com> (sfid-20160815_095933_480585_0BCB63CC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maxim Altshul <maxim.altshul@ti.com> writes:

> - The variable is added to allow the driver an easy access
> to it's own hw->priv when the op is invoked.
>
> - Change wlcore op accordingly.
>
> Signed-off-by: Maxim Altshul <maxim.altshul@ti.com>

You didn't CC linux-wireless, adding it now. Others can find the full
discussion here:

http://lkml.kernel.org/g/20160804124314.7636-2-maxim.altshul@ti.com

-- 
Kalle Valo
