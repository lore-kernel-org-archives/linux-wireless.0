Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4686 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2999010AbdDZLI1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 07:08:27 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michael Mera <dev@michaelmera.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RESEND] ath10k: fix out of bounds access to local buffer
Date: Wed, 26 Apr 2017 11:08:22 +0000
Message-ID: <87r30fxw7u.fsf@kamboji.qca.qualcomm.com> (sfid-20170426_130831_364239_8A7F9B1E)
References: <20170424071157.6979-1-dev@michaelmera.com>
        <0a7aa133740b4488a19bd95115831988@euamsexm01a.eu.qualcomm.com>
        <87a873wjak.fsf@michaelmera.com>
In-Reply-To: <87a873wjak.fsf@michaelmera.com> (Michael Mera's message of "Wed,
        26 Apr 2017 19:32:51 +0900")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Mera <dev@michaelmera.com> writes:

> Kalle Valo <kvalo@qca.qualcomm.com> writes:
>> I fixed a checkpatch warning in the pending branch:
>>
>> drivers/net/wireless/ath/ath10k/debug.c:636: spaces preferred around
>> that '-' (ctx:VxV)
>
> Hum... but then you will have a line longer than 80 characters (81), so
> another warning.

I have extended the line length in my check script to 90 chars just
because of cases like this:

https://wireless.wiki.kernel.org/en/users/drivers/ath10k/codingstyle#checki=
ng_code

> I prefered this version since I feel that splitting this line would hurt
> readability and on the other hand the expression is clearly delimited
> by the spaces around the ',' so I don't think spaces around the operator
> add any value (except for compliance with the coding style that is).

I actually guessed why you did that. But I want to keep the output of my
test script clean, makes review a lot easier. Making exceptions to the
script is more work for me.

Anyway, I already did the change in my pending branch and will apply the
patch in few days. Thanks for the fix.

--=20
Kalle Valo=
