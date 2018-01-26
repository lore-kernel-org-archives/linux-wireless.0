Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50576 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752193AbeAZOf3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 09:35:29 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: Re: [PATCH] ath9k: Fix get channel default noise floor
References: <1516976454-8883-1-git-send-email-Wojciech.Dubowik@neratec.com>
Date: Fri, 26 Jan 2018 16:35:24 +0200
In-Reply-To: <1516976454-8883-1-git-send-email-Wojciech.Dubowik@neratec.com>
        (Wojciech Dubowik's message of "Fri, 26 Jan 2018 15:20:54 +0100")
Message-ID: <87k1w4u1qr.fsf@kamboji.qca.qualcomm.com> (sfid-20180126_153533_685610_3528BE09)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wojciech Dubowik <Wojciech.Dubowik@neratec.com> writes:

> Commit 8da58553cc63 ("ath9k: Use calibrated noise floor value
> when available") introduced regression in ath9k_hw_getchan_noise
> where per chain nominal noise floor has been taken instead default
> for channel.
> Revert to original default channel noise floor.
>
> Reported-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
> Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>

Fixes: 8da58553cc63 ("ath9k: Use calibrated noise floor value when available")

I can add that if this passes Sebastian's tests.

And I'm planning to queue this for 4.16.

-- 
Kalle Valo
