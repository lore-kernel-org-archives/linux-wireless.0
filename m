Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36186 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbcC3Miu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 08:38:50 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	<devicetree@vger.kernel.org>,
	Wei-Ning Huang <wnhuang@chromium.org>,
	Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH v5 2/4] mwifiex: add platform specific wakeup interrupt support
References: <1458299032-31929-1-git-send-email-akarwar@marvell.com>
	<1458299032-31929-2-git-send-email-akarwar@marvell.com>
Date: Wed, 30 Mar 2016 15:38:44 +0300
In-Reply-To: <1458299032-31929-2-git-send-email-akarwar@marvell.com>
	(Amitkumar Karwar's message of "Fri, 18 Mar 2016 04:03:52 -0700")
Message-ID: <87a8lg5eej.fsf@purkki.adurom.net> (sfid-20160330_143914_685030_70EB83C5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

> From: Xinming Hu <huxm@marvell.com>
>
> On some arm-based platforms, we need to configure platform specific
> parameters by device tree node and also define our node as a child
> node of parent SDIO host controller.
> This patch parses these parameters from device tree. It includes
> calibration data dowoload to firmware, wakeup pin configured to firmware,
> and soc specific wake up gpio, which will be set as wakeup interrupt pin.
>
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

I only see patch 2, where are the rest three? Also it's not clear what's
the plan with this patchset.

-- 
Kalle Valo
