Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:57382 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180AbbAWUY3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 15:24:29 -0500
Message-ID: <54C2ADFB.2080806@lwfinger.net> (sfid-20150123_212438_601138_E746131B)
Date: Fri, 23 Jan 2015 14:24:27 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless@vger.kernel.org, Troy Tan <troy_tan@realsil.com.cn>,
	netdev@vger.kernel.org
Subject: Re: [PATCH 3/6] rtlwifi: btcoexist: Add routines for RTL8812AE with
 single antenna
References: <1422033044-7461-1-git-send-email-Larry.Finger@lwfinger.net>	<1422033044-7461-4-git-send-email-Larry.Finger@lwfinger.net> <87r3uljm7o.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87r3uljm7o.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/23/2015 02:06 PM, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>
>> From: Troy Tan <troy_tan@realsil.com.cn>
>>
>> The RTL8812AE needs different BT coexistence routines than does the
>> RTL8821AE. This patch adds the necessary routines for devices with a
>> single antenna.
>>
>> Signed-off-by: Troy Tan <troy_tan@realsil.com.cn>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> ---
>>   .../wireless/rtlwifi/btcoexist/halbtc8812a1ant.c   | 2073 ++++++++++++++++++++
>>   .../wireless/rtlwifi/btcoexist/halbtc8812a1ant.h   |  152 ++
>>   2 files changed, 2225 insertions(+)
>>   create mode 100644 drivers/net/wireless/rtlwifi/btcoexist/halbtc8812a1ant.c
>>   create mode 100644 drivers/net/wireless/rtlwifi/btcoexist/halbtc8812a1ant.h
>>
>> diff --git a/drivers/net/wireless/rtlwifi/btcoexist/halbtc8812a1ant.c b/drivers/net/wireless/rtlwifi/btcoexist/halbtc8812a1ant.c
>> new file mode 100644
>> index 0000000..11ae66b
>> --- /dev/null
>> +++ b/drivers/net/wireless/rtlwifi/btcoexist/halbtc8812a1ant.c
>> @@ -0,0 +1,2073 @@
>> +/*  */
>> +/*  Description: */
>> +/*  */
>> +/*  This file is for 8812a1ant Co-exist mechanism */
>> +/*  */
>> +/*  History */
>> +/*  2012/11/15 Cosa first check in. */
>> +/*  */
>> +/*  */
>> +
>> +/*  */
>> +/*  include files */
>> +/*  */
>
> One problem I see is that there's no license on either of the files. It
> would be much better if the files had that.

I will add that and send a V2 after I wait a while for any other comments.

Thanks,

Larry



