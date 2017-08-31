Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53954 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750895AbdHaM6P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 08:58:15 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/5] qtnfmac: drop -D__CHECK_ENDIAN from cflags
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170829121623.24761-2-sergey.matyukevich.os@quantenna.com>
References: <20170829121623.24761-2-sergey.matyukevich.os@quantenna.com>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Message-Id: <20170831125814.A999561794@smtp.codeaurora.org> (sfid-20170831_145818_344779_B31EC3DF)
Date: Thu, 31 Aug 2017 12:58:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> wrote:

> Flag -D__CHECK_ENDIAN was wrong: it should be -D__CHECK_ENDIAN__ instead.
> However now this flag is enabled by default, so it can be removed.
> 
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

5 patches applied to wireless-drivers-next.git, thanks.

57b18a75d90e qtnfmac: drop -D__CHECK_ENDIAN from cflags
97f38011451f qtnfmac: module param sanity check
bab5dac73c08 qtnfmac: modify qtnf_map_bar not to return NULL
b00edea3ed5f qtnfmac: fix free_xfer_buffer cleanup
f31039d4aea9 qtnfmac: implement 64-bit dma support

-- 
https://patchwork.kernel.org/patch/9927237/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
