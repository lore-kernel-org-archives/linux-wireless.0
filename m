Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44494 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938698AbcKQGp4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 01:45:56 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: p54: memset(0) whole array
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20161014092309.24113-1-jslaby@suse.cz>
References: <20161014092309.24113-1-jslaby@suse.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: chunkeey@googlemail.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Message-Id: <20161117064555.F21F6615DB@smtp.codeaurora.org> (sfid-20161117_074600_483262_863062BB)
Date: Thu, 17 Nov 2016 06:45:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Slaby <jslaby@suse.cz> wrote:
> gcc 7 complains:
> drivers/net/wireless/intersil/p54/fwio.c: In function 'p54_scan':
> drivers/net/wireless/intersil/p54/fwio.c:491:4: warning: 'memset' used with length equal to number of elements without multiplication by element size [-Wmemset-elt-size]
> 
> Fix that by passing the correct size to memset.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Christian Lamparter <chunkeey@googlemail.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Acked-by: Christian Lamparter <chunkeey@googlemail.com>

Patch applied to wireless-drivers-next.git, thanks.

6f1758178820 p54: memset(0) whole array

-- 
https://patchwork.kernel.org/patch/9376333/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
