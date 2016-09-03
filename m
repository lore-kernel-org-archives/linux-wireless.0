Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24963 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753471AbcICRfj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 13:35:39 -0400
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
Message-ID: <f70422725ef541e6af08136a61aacba5@euamsexm01a.eu.qualcomm.com> (sfid-20160903_193600_481089_9DB13D77)
Date: Sat, 3 Sep 2016 19:35:29 +0200
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

I'm planning to queue this to 4.8 if no objections.

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9309829/
