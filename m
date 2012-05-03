Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:56951 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752900Ab2ECH5x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 03:57:53 -0400
Received: by lagv3 with SMTP id v3so1271096lag.41
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 00:57:50 -0700 (PDT)
Message-ID: <1336031868.12189.24.camel@cumari.coelho.fi> (sfid-20120503_095757_789147_1BC21BD9)
Subject: Re: [PATCH] wl12xx: Init 80211 items before register irq
From: Luciano Coelho <coelho@ti.com>
To: Yingang Fu <yingang.fu@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	yingang.fu@borqs.com
Date: Thu, 03 May 2012 10:57:48 +0300
In-Reply-To: <CAHPDcRsY2HN7NrrorBhhqPCiV2nG2BDC_n_eFTxBtGyt5REe4A@mail.gmail.com>
References: <CAHPDcRsY2HN7NrrorBhhqPCiV2nG2BDC_n_eFTxBtGyt5REe4A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sat, 2012-03-10 at 12:21 +0800, Yingang Fu wrote:
> There is a race condition during wl12xx_probe that the interrupt
> may arrives before the probe completed. An irq could triggers an
> irq thread to run to process the irq work but the probe process has
> not finished.
> ---

The Signed-off-by tag is missing here, so I can't apply this patch.
Also, there were a bunch of checkpatch warnings, because you have used
spaces instead of TABs for indentation.

Can you please resend this patch with these fixes?

-- 
Cheers,
Luca.

