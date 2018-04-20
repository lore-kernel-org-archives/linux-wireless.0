Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38488 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754321AbeDTKTL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 06:19:11 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Andres Rodriguez <andresx7@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        mcgrof@kernel.org, alexdeucher@gmail.com,
        ckoenig.leichtzumerken@gmail.com, arend.vanspriel@broadcom.com,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 8/9] ath10k: use request_firmware_nowarn to load firmware
References: <20180417153307.3693-1-andresx7@gmail.com>
        <20180417153307.3693-9-andresx7@gmail.com>
Date: Fri, 20 Apr 2018 13:19:06 +0300
In-Reply-To: <20180417153307.3693-9-andresx7@gmail.com> (Andres Rodriguez's
        message of "Tue, 17 Apr 2018 11:33:06 -0400")
Message-ID: <87lgdii3j9.fsf@kamboji.qca.qualcomm.com> (sfid-20180420_121926_804626_7D955FFC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(adding linux-wireless and ath10k lists)

Andres Rodriguez <andresx7@gmail.com> writes:

> This reduces the unnecessary spew when trying to load optional firmware:
> "Direct firmware load for ... failed with error -2"
>
> Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
> ---
>  drivers/net/wireless/ath/ath10k/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Kalle Valo <kvalo@codeaurora.org>

But I think it would be good to change also request_firmware_direct() in
ath10k/testmode.c to request_firmware_nowarn().

-- 
Kalle Valo
