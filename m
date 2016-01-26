Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:25181 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965184AbcAZPBg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 10:01:36 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Raja Mani <rmani@qti.qualcomm.com>
CC: <agross@codeaurora.org>, <devicetree@vger.kernel.org>,
	<linux-arm-msm@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH v3] dt: bindings: add bindings for ipq4019 wifi block
References: <1452664604-8014-1-git-send-email-rmani@qti.qualcomm.com>
Date: Tue, 26 Jan 2016 17:01:17 +0200
In-Reply-To: <1452664604-8014-1-git-send-email-rmani@qti.qualcomm.com> (Raja
	Mani's message of "Wed, 13 Jan 2016 11:26:44 +0530")
Message-ID: <87y4bcpepu.fsf@kamboji.qca.qualcomm.com> (sfid-20160126_160158_827955_ADF47F47)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Raja Mani <rmani@qti.qualcomm.com> writes:

> Add device tree binding documentation details for wifi block present
> in Qualcomm IPQ4019 SoC into "qcom,ath10k.txt".
>
> Right now, ath10k wireless driver has support for PCI based wlan devices.
> There is a plan to extend ath10k driver to support wifi devices which are
> connected over AHB as well (enumeration will happen via device tree node).
> For AHB based devices (ie, ipq4019), all wifi properties are supplied via
> device tree (including irq, reg addr, cal data,etc).
>
> Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo
