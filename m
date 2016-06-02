Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43372 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210AbcFBO6e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2016 10:58:34 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: ath10k: enable ipq4019 device probe in ahb module
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1464613883-24036-1-git-send-email-c_traja@qti.qualcomm.com>
To: <c_traja@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>,
	Tamizh chelvam <c_traja@qti.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Message-ID: <1d9f58c8d04842c19383fc5c9d84a442@euamsexm01a.eu.qualcomm.com> (sfid-20160602_165837_351626_15731F42)
Date: Thu, 2 Jun 2016 16:58:26 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

c_traja@qti.qualcomm.com wrote:
> From: Raja Mani <rmani@qti.qualcomm.com>
> 
> All the necessary patches to make wifi running (over AHB)
> on ipq4019 SoC are ready now. It's good to enable
> ipq4019 wifi device probing in ahb module and
> remove work in progress debug print.
> 
> Device tree change is there in the public review by
> below commit message
> "qcom: ipq4019: add wifi nodes to ipq4019 SoC device tree"
> 
> Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
> Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>

Thanks, 1 patch applied to ath.git:

280e762e9c72 ath10k: enable ipq4019 device probe in ahb module

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9141355/

