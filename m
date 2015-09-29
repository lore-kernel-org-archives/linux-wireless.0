Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34854 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592AbbI2He5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2015 03:34:57 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: ath9k: enable hw manual peak calibration for QCA9561
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1441076169-13398-1-git-send-email-miaoqing@qca.qualcomm.com>
To: miaoqing pan <miaoqing@qti.qualcomm.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<ath9k-devel@qca.qualcomm.com>, <kvalo@qca.qualcomm.com>,
	Miaoqing Pan <miaoqing@qti.qualcomm.com>
Message-Id: <20150929073457.29722140C06@smtp.codeaurora.org> (sfid-20150929_093502_363703_AF9A051E)
Date: Tue, 29 Sep 2015 07:34:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Miaoqing Pan <miaoqing@qca.qualcomm.com>
> 
> This patch fix https://lists.openwrt.org/pipermail/openwrt-devel/
> 2015-August/034979.html. As the peak detect calibration is set
> incorrectly.
> 
> Signed-off-by: Miaoqing Pan <miaoqing@qca.qualcomm.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
