Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54252 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756613AbcKXL7L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Nov 2016 06:59:11 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: IgorMitsyanko <igor.mitsyanko.os@quantenna.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>, <btherthala@quantenna.com>,
        <hwang@quantenna.com>, <smaksimenko@quantenna.com>,
        <dlebed@quantenna.com>, Igor Mitsyanko <imitsyanko@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Kyle McMartin <kyle@kernel.org>
Subject: Re: [RFC] qtn: add FullMAC firmware for Quantenna QSR10G wifi device
References: <1478700000-11624-1-git-send-email-igor.mitsyanko.os@quantenna.com>
        <1478706966.18306.1.camel@sipsolutions.net>
        <2fcb5f28-808e-f296-7e91-e5185e7577c9@quantenna.com>
        <1478725543.21403.4.camel@sipsolutions.net>
        <d1cfaf8a-55a6-3a7c-9e9d-ec810fe5b80d@quantenna.com>
        <1478864146.4129.4.camel@sipsolutions.net>
        <a5075f50-25c6-18a1-bd5b-309927dacdab@quantenna.com>
        <87d1hmnrqj.fsf@purkki.adurom.net>
        <a5fa00c7-f8db-708a-cd21-4d5b0fbdf49b@quantenna.com>
Date: Thu, 24 Nov 2016 13:59:03 +0200
In-Reply-To: <a5fa00c7-f8db-708a-cd21-4d5b0fbdf49b@quantenna.com>
        (IgorMitsyanko's message of "Wed, 23 Nov 2016 20:09:32 +0300")
Message-ID: <87shqhf5rs.fsf@kamboji.qca.qualcomm.com> (sfid-20161124_125923_426770_F4633F9F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IgorMitsyanko <igor.mitsyanko.os@quantenna.com> writes:

> On 11/23/2016 06:25 PM, Kalle Valo wrote:
>> IgorMitsyanko <igor.mitsyanko.os@quantenna.com> writes:
>>
>>> To clarify with you and Kalle, as persons involved with
>>> linux-wireless: is my understanding correct that submitting firmware
>>> into linux-fimware repository is a prerequisite to accepting new
>>> driver into linux-wireless?
>> In my opinion the most important is that the device is usable with an
>> upstream driver so that anyone can start using the driver (if they have
>> the hardware).
>>
>>> There is an option to start Quantenna device from internal flash
>>> memory, no external binary files involved. If we will introduce this
>>> functionality and remove code handling external firmware for now
>>> (until firmware problem resolved), would that allow driver to be
>>> reviewed/accepted?
>> Do all the publically available hardware contain the firmware in
>> internal flash (flashed in the factory)? Or is this something which must
>> be installed separately for each board's internal flash by the user?
>
> Each board must have flash installed on it, preflashed in the factory
> with uboot and firmware binary, otherwise board won't boot 

Will the preflashed firmware binary will have all the normal
functionality needed by this driver? I mean that you can start an AP
interface etc.

> (won't boot without uboot, firmware itself is not mandatory).

Are you expecting that there are devices on the field which have uboot
preflashed but not the firmware?

> Booting from flash is default behavior on boards that are currently on
> the market, but for developemnt purpuses it's not very convenient and
> harder to upgrade.

Sure, I understand.

>> BTW, the original mail with the firmware image didn't make it to the
>> list, I guess it was too big? It would be good if you could post the
>> license separately so that people can see it.
>>
>
> I resent the email without binary patch to linux-wireless.

Saw it now, thanks.

-- 
Kalle Valo
