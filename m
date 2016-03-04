Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8512 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758803AbcCDIdK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 03:33:10 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "miaoqing@codeaurora.org" <miaoqing@codeaurora.org>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH] ath9k: clear bb filter calibration power threshold
Date: Fri, 4 Mar 2016 08:32:56 +0000
Message-ID: <871t7q1w3w.fsf@kamboji.qca.qualcomm.com> (sfid-20160304_093356_110549_677FC167)
References: <1455787202-8194-1-git-send-email-miaoqing@codeaurora.org>
In-Reply-To: <1455787202-8194-1-git-send-email-miaoqing@codeaurora.org>
	(miaoqing@codeaurora.org's message of "Thu, 18 Feb 2016 17:20:02	+0800")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

miaoqing@codeaurora.org writes:

> From: Miaoqing Pan <miaoqing@codeaurora.org>
>
> JP WiFi certification for bandwidth of channel 14 failed, the OBW
> is lower than the requirement. Clear the bb filter calibration power
> threshold to increase OBW(+2). The fix only for qca9531 chip now.
>
> Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>

Applied to ath.git, thanks.

-- 
Kalle Valo