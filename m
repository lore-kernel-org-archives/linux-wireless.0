Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:23697 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752777AbdLNPTy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 10:19:54 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: handling qos at STA side based on AP WMM enable/disable
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1511863650-9419-1-git-send-email-bpothuno@qti.qualcomm.com>
References: <1511863650-9419-1-git-send-email-bpothuno@qti.qualcomm.com>
To: <bpothuno@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Balaji Pothunoori" <bpothuno@qti.qualcomm.com>
Message-ID: <da2cd6fa88db42ab94207e5551c9be69@euamsexm01a.eu.qualcomm.com> (sfid-20171214_162039_058674_A63AEB99)
Date: Thu, 14 Dec 2017 16:19:41 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bpothuno@qti.qualcomm.com wrote:

> Data packets are not sent by STA in case of STA joined to
> non QOS AP (WMM disabled AP). This is happening because of STA
> is sending data packets to firmware from host with qos enabled
> along with non qos queue value(TID = 16).
> Due to qos enabled, firmware is discarding the packet.
> 
> This patch fixes this issue by updating the qos based on station
> WME capability field if WMM is disabled in AP.
> 
> This patch is required by 10.4 family chipsets like
> QCA4019/QCA9888/QCA9884/QCA99X0.
> Firmware Versoin : 10.4-3.5.1-00018.
> 
> For 10.2.4 family chipsets QCA988X/QCA9887 and QCA6174 this patch
> has no effect.
> 
> Signed-off-by: Balaji Pothunoori <bpothuno@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

07ffb4497360 ath10k: handling qos at STA side based on AP WMM enable/disable

-- 
https://patchwork.kernel.org/patch/10079089/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
