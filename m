Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28331 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746AbcGHOAr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 10:00:47 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/6] wcn36xx: Fold indication payload into message header
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1466403588-7041-1-git-send-email-bjorn.andersson@linaro.org>
To: Bjorn Andersson <bjorn.andersson@linaro.org>
CC: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	<wcn36xx@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-msm@vger.kernel.org>,
	"Bjorn Andersson" <bjorn.andersson@sonymobile.com>
Message-ID: <1521d56c490b4e74a67fe6a367a672f6@euamsexm01a.eu.qualcomm.com> (sfid-20160708_160057_021163_30019800)
Date: Fri, 8 Jul 2016 16:00:37 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bjorn Andersson <bjorn.andersson@linaro.org> wrote:
> From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> 
> Merge the two allocation instead of separately allocating room for the
> indication payload.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Thanks, 5 patches applied to ath-next branch of ath.git:

909aa60c0572 wcn36xx: Fold indication payload into message header
1c41fd5fb751 wcn36xx: Change indication list lock to spinlock
05ddce497c05 wcn36xx: Split mmio space into explicit regions
6f10b4e1e6ad wcn36xx: Correct DXE chip version differentiation
86ceae90d3f9 wcn36xx: Fix up wcn36xx_smd_update_scan_params()

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9186689/

