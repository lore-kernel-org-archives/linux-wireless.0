Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:51655 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752667Ab1LOIxb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 03:53:31 -0500
Received: by lagu2 with SMTP id u2so1005608lag.23
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2011 00:53:28 -0800 (PST)
Subject: Re: [PATCH] wl12xx: Restore testmode ABI
From: Luciano Coelho <coelho@ti.com>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1322738024-16626-1-git-send-email-pontus.fuchs@gmail.com>
References: <1322738024-16626-1-git-send-email-pontus.fuchs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Dec 2011 10:53:23 +0200
Message-ID: <1323939203.2800.177.camel@cumari> (sfid-20111215_095335_262743_2B158453)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-12-01 at 12:13 +0100, Pontus Fuchs wrote: 
> Commit 80900d0140a7648587982c8f299830e900e49165 accidently broke
> the ABI for testmode commands. Restore the ABI again.
> 
> Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
> Cc: stable@kernel.org
> ---

Applied, thanks!

-- 
Cheers,
Luca.

