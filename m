Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19949 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754667AbcIGNYC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Sep 2016 09:24:02 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: bring back direction setting in ath9k_{start_stop}
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20160901174702.8645-1-giedrius.statkevicius@gmail.com>
To: Giedrius Statkevi?ius <giedrius.statkevicius@gmail.com>
CC: <kvalo@codeaurora.org>, <ath9k-devel@qca.qualcomm.com>,
        <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Miaoqing Pan <miaoqing@codeaurora.org>,
        <stable@vger.kernel.org>,
        =?UTF-8?q?Giedrius=20Statkevi=C4=8Dius?=
        <giedrius.statkevicius@gmail.com>
Message-ID: <a331907578a94d2c8adc0de4362039e4@euamsexm01a.eu.qualcomm.com> (sfid-20160907_152445_911328_8E8B6828)
Date: Wed, 7 Sep 2016 15:23:06 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Giedrius Statkevi?ius <giedrius.statkevicius@gmail.com> wrote:
> A regression was introduced in commit id 79d4db1214a ("ath9k: cleanup
> led_pin initial") that broken the WLAN status led on my laptop with
> AR9287 after suspending and resuming.
> 
> Steps to reproduce:
> * Suspend (laptop)
> * Resume (laptop)
> * Observe that the WLAN led no longer turns ON/OFF depending on the
>   status and is always red
> 
> Even though for my case it only needs to be set to OUT in ath9k_start
> but for consistency bring back the IN direction setting as well.
> 
> Cc: Miaoqing Pan <miaoqing@codeaurora.org>
> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Giedrius Statkevičius <giedrius.statkevicius@gmail.com>

Thanks, 1 patch applied to ath-current branch of ath.git:

e34f2ff40e03 ath9k: bring back direction setting in ath9k_{start_stop}

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9309829/
