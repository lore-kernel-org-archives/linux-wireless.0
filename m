Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21837 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751671AbdBSOAA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 19 Feb 2017 09:00:00 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC v3 0/8] ath10k sdio support
Date: Sun, 19 Feb 2017 13:59:48 +0000
Message-ID: <8737fagu28.fsf@kamboji.qca.qualcomm.com> (sfid-20170219_150028_141809_4D54DFC4)
References: <1484342771-6160-1-git-send-email-erik.stromdahl@gmail.com>
        <87fujbhb29.fsf@kamboji.qca.qualcomm.com>
        <1c87e0d1-1f14-08bb-2a69-650788fba8dc@gmail.com>
        <877f4ngii5.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <877f4ngii5.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
        of "Sun, 19 Feb 2017 01:57:06 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Erik Stromdahl <erik.stromdahl@gmail.com> writes:
>
>> I was actually about to email you about this.
>>
>> I have made a few more updates to the sdio code so I think it would be
>> best if I could submit a new series of patches based on this code (v4).
>>
>> Then you can tweak it (v5).
>>
>> It is only minor updates to the HIF layer (added QCA9377 support) and
>> a setup of some pll registers.
>
> Ok, that sounds good. I'll wait for v4.

Forgot to mention can you run ath10k-check before submitting them, it
shows few problems:

https://wireless.wiki.kernel.org/en/users/drivers/ath10k/codingstyle#checki=
ng_code

But if you wonder what this is about it's checkpatch warning about camel
case (doesn't like the lower case x character):

drivers/net/wireless/ath/ath10k/sdio.h:68: <ATH10K_SDIO_DRIVE_DTSx_TYPE_C>

I guess I have a bug in the script when it parses checkpatch output.

--=20
Kalle Valo=
