Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:35689 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbbEKFB0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 01:01:26 -0400
Received: by widdi4 with SMTP id di4so90564634wid.0
        for <linux-wireless@vger.kernel.org>; Sun, 10 May 2015 22:01:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <554CF805.1050602@codeaurora.org>
References: <1431076388-24800-1-git-send-email-michal.kazior@tieto.com>
	<1431076388-24800-4-git-send-email-michal.kazior@tieto.com>
	<554CF805.1050602@codeaurora.org>
Date: Mon, 11 May 2015 07:01:24 +0200
Message-ID: <CA+BoTQmyJpByXjtjeGLxqaBz5VJ4+Ch3668kh7m576i4bhc_KQ@mail.gmail.com> (sfid-20150511_070132_251701_1E93E5D3)
Subject: Re: [PATCH 3/3] ath10k: enable pci soc powersaving
From: Michal Kazior <michal.kazior@tieto.com>
To: Peter Oh <poh@codeaurora.org>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 May 2015 at 19:53, Peter Oh <poh@codeaurora.org> wrote:
> Hi,
>
> On 05/08/2015 02:13 AM, Michal Kazior wrote:
[...]
>>   diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c
>> b/drivers/net/wireless/ath/ath10k/htt_rx.c
>> index b26e32f42656..889262b07d19 100644
>> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
>> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
>> @@ -22,6 +22,7 @@
>>   #include "debug.h"
>>   #include "trace.h"
>>   #include "mac.h"
>> +#include "hif.h"
>>
>
> Is it necessary change?

Good catch, thanks! This is a leftover from early prototyping of the
patch. I'll remove it in v2.


Michał
