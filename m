Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33365 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbbDGRPf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2015 13:15:35 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: ath9k: add extra GPIO led support
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1427854797-30332-1-git-send-email-miaoqing@qca.qualcomm.com>
To: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<ath9k-devel@qca.qualcomm.com>,
	Miaoqing Pan <miaoqing@qti.qualcomm.com>
Message-Id: <20150407171534.7C05A140D74@smtp.codeaurora.org> (sfid-20150407_191539_428690_A302E4E6)
Date: Tue,  7 Apr 2015 17:15:34 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Miaoqing Pan <miaoqing@qca.qualcomm.com>
> 
> ar9550 or later chips, the AR_GPIO_IN_OUT register only can
> control GPIO[0:3]. For the extra GPIO, use standard GPIO calls
> instead of WMAC internal registers.
> 
> Signed-off-by: Miaoqing Pan <miaoqing@qca.qualcomm.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
