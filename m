Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33269 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbcDMR4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2016 13:56:35 -0400
Subject: Re: [PATCH v2] qcom: ipq4019: add wifi nodes to ipq4019 SoC device
 tree
To: tamizhchelvam@codeaurora.org, agross@codeaurora.org,
	devicetree@vger.kernel.org
References: <1460434686-23010-1-git-send-email-tamizhchelvam@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, ath10k@lists.infradead.org,
	c_traja@qti.qualcomm.com, Raja Mani <rmani@codeaurora.org>
From: Stephen Boyd <sboyd@codeaurora.org>
Message-ID: <570E8850.9030506@codeaurora.org> (sfid-20160413_195639_274275_1390543D)
Date: Wed, 13 Apr 2016 10:56:32 -0700
MIME-Version: 1.0
In-Reply-To: <1460434686-23010-1-git-send-email-tamizhchelvam@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/11/2016 09:18 PM, tamizhchelvam@codeaurora.org wrote:
> +			qcom,msi_addr = <0x0b006040>;
> +			qcom,msi_base = <0x50>;

Are these properties used? I couldn't find any usage in the driver but I
may have missed it.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

