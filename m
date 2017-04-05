Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53734 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933245AbdDEK2G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 06:28:06 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] rsi: Rename the file rsi_91x_pkt.c to rsi_91x_hal.c
References: <1491282009-2854-1-git-send-email-prameela.j04cs@gmail.com>
Date: Wed, 05 Apr 2017 13:28:01 +0300
In-Reply-To: <1491282009-2854-1-git-send-email-prameela.j04cs@gmail.com>
        (Prameela Rani Garnepudi's message of "Tue, 4 Apr 2017 10:30:09
        +0530")
Message-ID: <87o9wbi1xq.fsf@kamboji.qca.qualcomm.com> (sfid-20170405_122904_372813_F7FD7FC3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prameela Rani Garnepudi <prameela.j04cs@gmail.com> writes:

> The file rsi_91x_hal.c will contain new firmware loading method for
> RSI 9113 chipset. So this file will have device specific operations.
> As the file 'rsi_91x_pkt.c' contains code for preparing device
> (frimware understandable) specific descriptors for the transmit frames,
> it is moved to 'rsi_91x_hal.c'
>
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

If you send a new version of the patchset mark it as "[PATCH v2]". Also
I don't see a changelog anywhere, what has changed since the version you
posted last December?

Please read:

https://kernelnewbies.org/FirstKernelPatch#head-5c81b3c517a1d0bbc24f92594cb734e155fcbbcb

-- 
Kalle Valo
