Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44774 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751304AbdEIPHv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2017 11:07:51 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Cc: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
        Dmitrii Lebed <dlebed@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Bindu Therthala <btherthala@quantenna.com>,
        Huizhao Wang <hwang@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH v5] qtnfmac: announcement of new FullMAC driver for Quantenna chipsets
References: <1489262657-8191-1-git-send-email-igor.mitsyanko.os@quantenna.com>
        <c80e4171-d433-6f31-f279-94aa5d238dc7@quantenna.com>
        <878tm69imk.fsf@purkki.adurom.net>
Date: Tue, 09 May 2017 18:07:46 +0300
In-Reply-To: <878tm69imk.fsf@purkki.adurom.net> (Kalle Valo's message of "Tue,
        09 May 2017 18:04:19 +0300")
Message-ID: <874lwu9igt.fsf@purkki.adurom.net> (sfid-20170509_170755_237039_24BC12E5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

>>> QSR10G (aka Pearl) is Quantenna's 8x8, 160M, 11ac offering.
>>> QSR10G supports 2 simultaneous WMACs - one 5G and one 2G.
>>> 5G WMAC supports 160M, 8x8 configuration. FW supports
>>> up to 8 concurrent virtual interfaces on each WMAC.
>>>
>>> Patch introduces 2 new drivers:
>>> - qtnfmac.ko for interfacing with kernel wireless core
>>> - qtnfmac_pearl_pcie.ko for interfacing with hardware over PCIe interface
>
> Please mention in the commit log also what modes (AP, managed, monitor
> etc) are supported.

Oh, and drop the word "announcement" from the title. Something like
"qtnfmac: add new FullMAC driver for Quantenna chipsets" is good enough.

-- 
Kalle Valo
