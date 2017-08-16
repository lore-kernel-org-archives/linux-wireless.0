Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43192 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751531AbdHPQ2T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Aug 2017 12:28:19 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH] qtnfmac: pcie datapath optimizations and cleanups
References: <20170815130638.31718-1-sergey.matyukevich.os@quantenna.com>
        <8760dntv1y.fsf@purkki.adurom.net>
        <20170816155313.xtl4vfq7m7zfu5dj@bars>
Date: Wed, 16 Aug 2017 19:28:14 +0300
In-Reply-To: <20170816155313.xtl4vfq7m7zfu5dj@bars> (Sergey Matyukevich's
        message of "Wed, 16 Aug 2017 18:53:14 +0300")
Message-ID: <87r2wb5vfl.fsf@kamboji.qca.qualcomm.com> (sfid-20170816_182822_591375_7FDE494E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

>> I don't see patch 9 in the mailing list. Did it get lost somewhere?
>
> No, this is my fault. The last patch was sort of experimental shuffling
> dma memory barriers. I kept it for testing, but forgot to remove it
> before sending. Let me know if it matters, then I will resend
> a properly numbered patchset.

Not a problem, I just always check if I see a patch missing.

-- 
Kalle Valo
