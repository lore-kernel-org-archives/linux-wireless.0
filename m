Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44868 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754570AbeDYODU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 10:03:20 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Anilkumar Kolli <akolli@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC v2] ath10k: report tx rate using ieee80211_tx_status()
References: <1524291786-30850-1-git-send-email-akolli@codeaurora.org>
        <87zi1tav6h.fsf@kamboji.qca.qualcomm.com>
        <6b57525f3edc2b7d06b7662efc5d7e5f@codeaurora.org>
Date: Wed, 25 Apr 2018 17:03:14 +0300
In-Reply-To: <6b57525f3edc2b7d06b7662efc5d7e5f@codeaurora.org> (Anilkumar
        Kolli's message of "Wed, 25 Apr 2018 15:29:37 +0530")
Message-ID: <87y3hb8jtp.fsf@kamboji.qca.qualcomm.com> (sfid-20180425_160333_070523_74C73F0F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Anilkumar Kolli <akolli@codeaurora.org> writes:

> On 2018-04-24 13:32, Kalle Valo wrote:
>> Anilkumar Kolli <akolli@codeaurora.org> writes:
>>
>>> Mesh path metric needs txrate information from ieee80211_tx_status()
>>> call but in ath10k there is no mechanism to report tx rate information
>>> via ieee80211_tx_status(), the rate is only accessible via
>>> sta_statiscs() op.
>>>
>>> Per peer stats has tx rate info available, this patch stores per peer
>>> last tx rate and updates the tx rate info structures in tx
>>> completition.
>>> The rate updated in ieee80211_tx_status() is not exactly for the last
>>> transmitted frame instead the rate is from one of the previous frames.
>>>
>>> Per peer txrate information is updated through per peer statistics
>>> and is available for QCA9888/QCA9984/QCA4019/QCA998X only
>>>
>>> Tested on QCA9984 with firmware-5.bin_10.4-3.5.3-00053
>>> Tested on QCA998X with firmware-5.bin_10.2.4-1.0-00036
>>>
>>> Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
>>
>> BTW, your name in patchwork is "akolli@codeaurora.org" but it should be
>> "Anilkumar Kolli" and that's why my script uses the wrong name. Please
>> fix it by registering to patchwork as it's possible to change your name
>> during registration, but only one time. If that doesn't work then
>> send a
>> request to helpdesk@kernel.org and the admins will fix it.
>
> I registered and updated name in the patchwork website.

It seems that your name still is "akolli@codeaurora.org" in the
Submitter field:

https://patchwork.kernel.org/patch/10353959/

An example how it should look like:

https://patchwork.kernel.org/patch/10359823/

I think you need to contact helpdesk now and ask them to fix it.

> Do I need to resend the patch ?

No need to resend because of this.

-- 
Kalle Valo
