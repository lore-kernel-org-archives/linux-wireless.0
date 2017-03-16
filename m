Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50774 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751384AbdCPI6W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 04:58:22 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: don't trigger spectral scan when not enabled
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1488206976-7775-1-git-send-email-zefir.kurtisi@neratec.com>
References: <1488206976-7775-1-git-send-email-zefir.kurtisi@neratec.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
CC: <linux-wireless@vger.kernel.org>
Message-ID: <04217d3c635f44e5bcc0743316fcc53b@euamsexm01a.eu.qualcomm.com> (sfid-20170316_095843_105019_24C31666)
Date: Thu, 16 Mar 2017 09:55:10 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
> Doing so enables the FFT generation without prior
> configuration, leading to an IRQ storm caused by
> invalid (or at least unwanted) PHY errors.
> 
> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>

Patch applied to ath-next branch of ath.git, thanks.

45c3d550b068 ath9k: don't trigger spectral scan when not enabled

-- 
https://patchwork.kernel.org/patch/9593623/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
