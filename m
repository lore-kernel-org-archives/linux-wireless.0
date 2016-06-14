Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32097 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbcFNL4z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2016 07:56:55 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3,1/2] ath10k: remove duplicate and unused rx rate flags
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1464877482-14620-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <8c7494314722406d9af8328fdc51b1ba@euamsexm01a.eu.qualcomm.com> (sfid-20160614_135657_955759_0FC6CF2C)
Date: Tue, 14 Jun 2016 13:56:44 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> All these flags are not used and their use is completely
> covered by 'ath10k_hw_rate_ofdm', 'ath10k_hw_rate_cck',
> and RX_PPDU_START_RATE_FLAG
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Thanks, 2 patches applied to ath-next branch of ath.git:

9cd24451859a ath10k: remove duplicate and unused rx rate flags
5269c65900d9 ath10k: fix CCK h/w rates for QCA99X0 and newer chipsets

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9150143/

