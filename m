Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23430 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758550AbcCDIev convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 03:34:51 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "miaoqing@codeaurora.org" <miaoqing@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH v2] ath9k: make NF load complete quickly and reliably
Date: Fri, 4 Mar 2016 08:34:45 +0000
Message-ID: <87twkmzlnh.fsf@kamboji.qca.qualcomm.com> (sfid-20160304_093455_562196_62734057)
References: <1454636750-2372-1-git-send-email-miaoqing@codeaurora.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

miaoqing@codeaurora.org writes:

> From: Miaoqing Pan <miaoqing@codeaurora.org>
>
> Make NF load complete quickly and reliably. NF load execution
> is delayed by HW to end of frame if frame Rx or Tx is ongoing.
> Increasing timeout to max frame duration. If NF cal is ongoing
> before NF load, stop it before load, and restart it afterwards.
>
> Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>

Applied to ath.git, thanks.

-- 
Kalle Valo