Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49150 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751530AbdHPPJG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Aug 2017 11:09:06 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH 2/9] qtnfmac: switch to napi_gro_receive
References: <20170815130638.31718-1-sergey.matyukevich.os@quantenna.com>
        <20170815130638.31718-3-sergey.matyukevich.os@quantenna.com>
        <871sobtuyc.fsf@purkki.adurom.net>
Date: Wed, 16 Aug 2017 18:08:59 +0300
In-Reply-To: <871sobtuyc.fsf@purkki.adurom.net> (Kalle Valo's message of "Wed,
        16 Aug 2017 18:04:43 +0300")
Message-ID: <87tw17sg6s.fsf@purkki.adurom.net> (sfid-20170816_170911_031009_5C279DB6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:
>
>> Use napi_gro_receive() rather than netif_receive_skb() in qtnfmac driver.
>
> Yes, I can easily see that from the diff so no need to document that :)
> But the commit log should tell _why_ you did it.

And no need to resend because of this, I can improve the commit log
during commit. Just let me know what I should add.

-- 
Kalle Valo
