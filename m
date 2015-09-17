Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:64117 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbbIQLTA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 07:19:00 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add ATH10K_FW_FEATURE_RAW_MODE_SUPPORT to ath10k_core_fw_feature_str[]
References: <20150909083437.12465.89335.stgit@potku.adurom.net>
Date: Thu, 17 Sep 2015 14:18:51 +0300
In-Reply-To: <20150909083437.12465.89335.stgit@potku.adurom.net> (Kalle Valo's
	message of "Wed, 09 Sep 2015 11:34:37 +0300")
Message-ID: <87zj0ltht0.fsf@kamboji.qca.qualcomm.com> (sfid-20150917_131904_188889_98719491)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> This was missed in the original commit adding the flag and ath10k only printed "bit10":
>
> ath10k_pci 0000:02:00.0: qca988x hw2.0 (0x4100016c, 0x043202ff) fw 10.2.4.70.6-2 api 3
> htt-ver 2.1 wmi-op 5 htt-op 2 cal otp max-sta 128 raw 0 hwcrypto 1 features no-p2p,bit10
>
> Also add a build test to avoid this happening again.
>
> Fixes: ccec9038c721 ("ath10k: enable raw encap mode and software crypto engine")
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Applied.

-- 
Kalle Valo
