Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60752 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754838AbcJMEv1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 00:51:27 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Steve deRosier <derosier@gmail.com>
Cc: Alan <alan@linux.intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6k1: add Dell OEM SDIO I/O for the Venue 8 Pro
References: <147629570687.26062.4786752681864367162.stgit@localhost.localdomain>
        <CALupW3D2dsTeixs3z+e9JC_D2D_Bd_AHquHKttCf17OhMqEFUg@mail.gmail.com>
Date: Thu, 13 Oct 2016 07:50:32 +0300
In-Reply-To: <CALupW3D2dsTeixs3z+e9JC_D2D_Bd_AHquHKttCf17OhMqEFUg@mail.gmail.com>
        (Steve deRosier's message of "Wed, 12 Oct 2016 14:32:18 -0700")
Message-ID: <87fuo026p3.fsf@purkki.adurom.net> (sfid-20161013_065137_312918_3AA87D1C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Steve deRosier <derosier@gmail.com> writes:

> Sorry to quibble, but the subsystem label on the commit subject line
> should be "ath6kl:"  it's a lower-case "L", not a one.

Heh, I missed that :) I can fix it before I commit.

>> --- a/drivers/net/wireless/ath/ath6kl/sdio.c
>> +++ b/drivers/net/wireless/ath/ath6kl/sdio.c
>> @@ -1401,6 +1401,7 @@ static const struct sdio_device_id ath6kl_sdio_devices[] = {
>>         {SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6004_BASE | 0x0))},
>>         {SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6004_BASE | 0x1))},
>>         {SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6004_BASE | 0x2))},
>> +       {SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6004_BASE | 0x18))},
>>         {},
>>  };
>>
>>
>
> I see nothing wrong with this if the chip does indeed identify itself
> this way.  So please fix the subject and you can add:
>
> Reviewed-by: Steve deRosier <steve.derosier@lairdtech.com>

Thanks.

-- 
Kalle Valo
