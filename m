Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0081.outbound.protection.outlook.com ([104.47.41.81]:6996
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751461AbdHPPx3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Aug 2017 11:53:29 -0400
Date: Wed, 16 Aug 2017 18:53:14 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH] qtnfmac: pcie datapath optimizations and cleanups
Message-ID: <20170816155313.xtl4vfq7m7zfu5dj@bars> (sfid-20170816_175333_416208_49A0877B)
References: <20170815130638.31718-1-sergey.matyukevich.os@quantenna.com>
 <8760dntv1y.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8760dntv1y.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I don't see patch 9 in the mailing list. Did it get lost somewhere?

No, this is my fault. The last patch was sort of experimental shuffling
dma memory barriers. I kept it for testing, but forgot to remove it
before sending. Let me know if it matters, then I will resend
a properly numbered patchset.

Regards,
Sergey
