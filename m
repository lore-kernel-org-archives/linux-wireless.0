Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52607 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757498AbcIGNL6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Sep 2016 09:11:58 -0400
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
Message-ID: <e61bb634860745818f8c8c99f79f71a0@euamsexm01a.eu.qualcomm.com> (sfid-20160907_151220_867633_ED6E5A6D)
Date: Wed, 7 Sep 2016 15:11:44 +0200
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

Thanks, 1 patch applied to ath-next branch of ath.git:

088a60926b66 ath9k: bring back direction setting in ath9k_{start_stop}

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9309829/
