Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:40535 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751314AbeBWOgz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Feb 2018 09:36:55 -0500
Subject: Re: [PATCH] rtlwifi: rtl8723be: Fix loss of signal
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Stable <stable@vger.kernel.org>
References: <20180222202859.16679-1-Larry.Finger@lwfinger.net>
 <87lgfkxdwn.fsf@kamboji.qca.qualcomm.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <e33e8482-25e1-9e03-f114-08e487c4907c@lwfinger.net> (sfid-20180223_153658_504425_622BE04F)
Date: Fri, 23 Feb 2018 08:36:52 -0600
MIME-Version: 1.0
In-Reply-To: <87lgfkxdwn.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/23/2018 03:18 AM, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
> 
>> In commit c713fb071edc ("rtlwifi: rtl8821ae: Fix connection lost problem
>> correctly") a problem in rtl8821ae that caused loss of signal was fixed.
>> That same problem has now been reported for rtl8723be. Accordingly,
>> the ASPM L1 latency has been increased from 0 to 7 to fix the instability.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: Stable <stable@vger.kernel.org>
>> ---
>> Kalle,
>>
>> This patch should be sent to 4.16.
> 
> Ok, I'll queue this for 4.16.

Thanks,

Larry
