Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2708 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbcF3LBd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 07:01:33 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Disable TX_STBC for tx chainmask of 1
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1466081713-8122-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <acc7cf0119594113851574777077856c@euamsexm01a.eu.qualcomm.com> (sfid-20160630_130201_461356_2FE8E460)
Date: Thu, 30 Jun 2016 13:01:03 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> Disable TX_STBC for both HT and VHT if the devices tx chainmask is '1'
> TX_STBC is required only for devices with tx_chainmask > 1. This fixes
> a ping failure for QCA9887 (1x1) in HT/VHT mode
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

34663241d81f ath10k: disable TX_STBC for tx chainmask of 1

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9180781/

