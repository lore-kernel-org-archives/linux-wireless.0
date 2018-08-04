Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58864 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbeHDIGk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 Aug 2018 04:06:40 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] mt76x0: rename mt76_* functions
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1533296680-7236-1-git-send-email-sgruszka@redhat.com>
References: <1533296680-7236-1-git-send-email-sgruszka@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Message-Id: <20180804060712.56AD260558@smtp.codeaurora.org> (sfid-20180804_080751_780274_6AEF5960)
Date: Sat,  4 Aug 2018 06:07:12 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> mt76_* functions conflicts with mt7601u driver what prevents to build
> those drivers in the kernel or use both drivers modules at once.
> 
> Patch fixes build errors like this:
> ld: drivers/net/wireless/mediatek/mt76/mt76x0/mac.o:(.opd+0x30): multiple definition of `mt76_mac_tx_rate_val'; drivers/net/wireless/mediatek/mt7601u/mac.o:(.opd+0x30): first defined here
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Fixes: 7b4859026ccd ("mt76x0: core files")
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

2 patches applied to wireless-drivers-next.git, thanks.

909da6e4b577 mt76x0: rename mt76_* functions
e800a333135b mt76x0: rename trace symbols

-- 
https://patchwork.kernel.org/patch/10555033/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
