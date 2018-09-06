Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39844 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbeIFUwi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 16:52:38 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [RFC v5 01/12] ath10k: add struct ath10k_bus_params
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180603182029.8914-2-erik.stromdahl@gmail.com>
References: <20180603182029.8914-2-erik.stromdahl@gmail.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
Cc: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org,
        Erik Stromdahl <erik.stromdahl@gmail.com>
Message-Id: <20180906161624.833D760710@smtp.codeaurora.org> (sfid-20180906_181627_530875_C0A0F4CD)
Date: Thu,  6 Sep 2018 16:16:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> wrote:

> This struct is used as argument to ath10k_core_register in order to
> make it easier to add more bus parameters in the future.
> 
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

12 patches applied to ath-next branch of ath.git, thanks.

c0d8d565787c ath10k: add struct ath10k_bus_params
7c2dd6154fc2 ath10k: add device type enum to ath10k_bus_params
367c899f622c ath10k: add bus type check in ath10k_init_hw_params
9faaa14387fb ath10k: use hw_params.num_peers for num_tids in TLV init
4875e0b52085 ath10k: add per target config of max_num_peers
e66d5361127a ath10k: DMA related fixes for high latency devices
852d1bf86a5b ath10k: add HTT TX HL ops
d4e7f553eec3 ath10k: add HTT RX HL ops
4daacc950d4d ath10k: htt: RX ring config HL support
a2097d6444c3 ath10k: htt: High latency TX support
f88d49345040 ath10k: htt: High latency RX support
37f62c0d5822 ath10k: wmi: disable softirq's while calling ieee80211_rx

-- 
https://patchwork.kernel.org/patch/10445507/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
