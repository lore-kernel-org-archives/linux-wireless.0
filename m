Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47462 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751672AbdITMdV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 08:33:21 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net
Subject: Re: [V2, 1/9] qtnfmac: qlink: convert channel width from bitfiled to simple enum
References: <20170902014451.17766-2-igor.mitsyanko.os@quantenna.com>
        <20170920122314.5397A60710@smtp.codeaurora.org>
Date: Wed, 20 Sep 2017 15:33:17 +0300
In-Reply-To: <20170920122314.5397A60710@smtp.codeaurora.org> (Kalle Valo's
        message of "Wed, 20 Sep 2017 12:23:14 +0000 (UTC)")
Message-ID: <871sn1zh0y.fsf@purkki.adurom.net> (sfid-20170920_143324_837277_4C31AEC2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Igor Mitsyanko <igor.mitsyanko.os@quantenna.com> wrote:
>
>> From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
>> 
>> Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
>> Reviewed-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
>
> No empty commit logs, please. After the first patch I was about to write
> one myself but after seeing multiple of them I'm not going to do that.
>
> 9 patches set to Changes Requested.

BTW, I got a mail undelivered message. Not sure why smtp.codeaurora.org
could not find the host but reporting it here just in case:

<avinashp@quantenna.com>: unable to look up host
    quantenna-com.mail.protection.outlook.com: Name or service not known

<igor.mitsyanko.os@quantenna.com>: unable to look up host
    quantenna-com.mail.protection.outlook.com: Name or service not known

<sergey.matyukevich.os@quantenna.com>: unable to look up host
    quantenna-com.mail.protection.outlook.com: Name or service not known

-- 
Kalle Valo
