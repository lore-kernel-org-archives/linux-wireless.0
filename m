Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54697 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbcGSHWY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 03:22:24 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Eyal Reizer <eyalreizer@gmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-spi@vger.kernel.org, robh@kernel.org,
	Eyal Reizer <eyalr@ti.com>
Subject: Re: [PATCH v7] wlcore: spi: add wl18xx support
References: <1468911482-32560-1-git-send-email-eyalr@ti.com>
Date: Tue, 19 Jul 2016 10:22:18 +0300
In-Reply-To: <1468911482-32560-1-git-send-email-eyalr@ti.com> (Eyal Reizer's
	message of "Tue, 19 Jul 2016 09:58:02 +0300")
Message-ID: <87poqaum6t.fsf@kamboji.qca.qualcomm.com> (sfid-20160719_092254_431989_1943C51C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eyal Reizer <eyalreizer@gmail.com> writes:

> From: Eyal Reizer <eyalreizer@gmail.com>
>
> Add support for using with both wl12xx and wl18xx.
>
> - all wilink family needs special init command for entering wspi mode.
>   extra clock cycles should be sent after the spi init command while the
>   cs pin is high.
> - Use inverted chip select for sending a dummy 4 bytes command that
>   completes the init stage.
>
> Signed-off-by: Eyal Reizer <eyalr@ti.com>
> Acked-by: Rob Herring <robh@kernel.org>

This looks ok in patchwork:

https://patchwork.kernel.org/patch/9235983/

Because you used ti.com in S-o-b I assume From should also use ti.com. I
can fix that before I apply but please confirm that's really the case?

-- 
Kalle Valo
