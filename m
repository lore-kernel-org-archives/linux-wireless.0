Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45178 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab1LUR1C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 12:27:02 -0500
Received: by ghbz12 with SMTP id z12so4962643ghb.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 09:27:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1324442516.20505.1.camel@joe2Laptop>
References: <1324406771-7100-1-git-send-email-rodrigue@qca.qualcomm.com>
 <1324406771-7100-3-git-send-email-rodrigue@qca.qualcomm.com> <1324442516.20505.1.camel@joe2Laptop>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Wed, 21 Dec 2011 09:26:40 -0800
Message-ID: <CAB=NE6VkUNtc+gkz+U63n7f4Q4HH_y0u2seXU+RQ2zJYqr7G1A@mail.gmail.com> (sfid-20111221_182711_236976_086D25A2)
Subject: Re: [PATCH 2/6] ath9k: make ath_mci_duty_cycle static
To: Joe Perches <joe@perches.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 20, 2011 at 8:41 PM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2011-12-20 at 10:46 -0800, Luis R. Rodriguez wrote:
>> diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
> []
>> @@ -20,7 +20,7 @@
>>  #include "ath9k.h"
>>  #include "mci.h"
>>
>> -u8 ath_mci_duty_cycle[] = { 0, 50, 60, 70, 80, 85, 90, 95, 98 };
>> +static u8 ath_mci_duty_cycle[] = { 0, 50, 60, 70, 80, 85, 90, 95, 98 };
>
> static const would be better.

Good idea, v2 coming up.

  Luis
