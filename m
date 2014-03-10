Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:58980 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbaCJR1n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2014 13:27:43 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>
CC: <ath6kl@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/6] ath6kl: remove unnecessary line continuations
References: <20140309065606.10793.67068.stgit@x230>
	<20140309065729.10793.45052.stgit@x230>
	<1394399733.6972.47.camel@joe-AO722>
Date: Mon, 10 Mar 2014 19:26:25 +0200
In-Reply-To: <1394399733.6972.47.camel@joe-AO722> (Joe Perches's message of
	"Sun, 9 Mar 2014 14:15:33 -0700")
Message-ID: <8738iqm0ce.fsf@kamboji.qca.qualcomm.com> (sfid-20140310_182750_350965_63EEC5BF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:

> On Sun, 2014-03-09 at 08:57 +0200, Kalle Valo wrote:
>> Fixes checkpatch warning:
>> WARNING: Avoid unnecessary line continuations
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> []
>> diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
> []
>> @@ -45,8 +45,9 @@ module_param(testmode, uint, 0644);
>>  module_param(recovery_enable, uint, 0644);
>>  module_param(heart_beat_poll, uint, 0644);
>>  MODULE_PARM_DESC(recovery_enable, "Enable recovery from firmware error");
>> -MODULE_PARM_DESC(heart_beat_poll, "Enable fw error detection periodic"   \
>> -		 "polling. This also specifies the polling interval in"  \
>> +MODULE_PARM_DESC(heart_beat_poll,
>> +		 "Enable fw error detection periodic"
>> +		 "polling. This also specifies the polling interval in"
>>  		 "msecs. Set reocvery_enable for this to be effective");
>
> Couple things:
>
> o There's a missing space between periodic and polling
> o There's a typo of recovery
>
> My suggestion would be to use:
>
> MODULE_PARM_DESC(heart_beat_poll,
> 		 "Enable fw error detection periodic polling in msecs - Also set recovery_enable for this to be effective");

Thanks, I changed it to that.

-- 
Kalle Valo
