Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48536 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751803AbdDCL5U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Apr 2017 07:57:20 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        prameela.garnepudi@redpinesignals.com,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] rsi: Rename the file rsi_91x_pkt.c to rsi_91x_hal.c
References: <1490867055-2625-1-git-send-email-prameela.j04cs@gmail.com>
Date: Mon, 03 Apr 2017 14:57:15 +0300
In-Reply-To: <1490867055-2625-1-git-send-email-prameela.j04cs@gmail.com>
        (Prameela Rani Garnepudi's message of "Thu, 30 Mar 2017 15:14:15
        +0530")
Message-ID: <87r319n1pg.fsf@kamboji.qca.qualcomm.com> (sfid-20170403_135745_933550_035162A6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ linux-wireless

Prameela Rani Garnepudi <prameela.j04cs@gmail.com> writes:

> The file rsi_91x_hal.c will contain new firmware loading method for
> RSI 9113 chipset. So this file will have device specific operations.
> As the file 'rsi_91x_pkt.c' contains code for preparing device
> (frimware understandable) specific descriptors for the transmit frames,
> it is moved to 'rsi_91x_hal.c'
>
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Always remember CC linux-wireless for wireless patches. So please
resend.

-- 
Kalle Valo
