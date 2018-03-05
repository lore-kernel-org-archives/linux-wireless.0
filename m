Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:54953 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932858AbeCEN4c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Mar 2018 08:56:32 -0500
MIME-Version: 1.0
In-Reply-To: <87o9kjiz15.fsf@codeaurora.org>
References: <1519046379-10068-1-git-send-email-amitkarwar@gmail.com>
 <1519046379-10068-4-git-send-email-amitkarwar@gmail.com> <87o9kjiz15.fsf@codeaurora.org>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Mon, 5 Mar 2018 19:26:30 +0530
Message-ID: <CAEhWJFmw0BEpcaD9Z0HQCFHhwoU5eNag6ZtG1nKfdyygd36_+g@mail.gmail.com> (sfid-20180305_145637_805383_EE648C3F)
Subject: Re: [v7 3/8] rsi: add header file rsi_91x
To: Kalle Valo <kvalo@codeaurora.org>
Cc: David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave and Johannes,

On Tue, Feb 20, 2018 at 6:44 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Hi Dave and Johannes,
>
> a question to both of you below:
>
> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>
>> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>
>> The common parameters used by wlan and bt modules are add
>> to a new header file "rsi_91x.h" defined in 'include/net'
>>
>> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>> ---
>> v7: Same as v6
>> v6: Renamed rsi_header.h to rsi_91x.h and moved to include/net
>>     from include/linux(Kalle)
>> v5: Same as earlier versions
>
> [...]
>
>> --- /dev/null
>> +++ b/include/net/rsi_91x.h
>> @@ -0,0 +1,34 @@
>> +/**
>> + * Copyright (c) 2017 Redpine Signals Inc.
>> + *
>> + * Permission to use, copy, modify, and/or distribute this software for any
>> + * purpose with or without fee is hereby granted, provided that the above
>> + * copyright notice and this permission notice appear in all copies.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
>> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
>> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
>> + * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
>> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
>> + * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
>> + * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
>> + */
>> +
>> +#ifndef __RSI_HEADER_H__
>> +#define __RSI_HEADER_H__
>> +
>> +/* HAL queue information */
>> +#define RSI_COEX_Q                   0x0
>> +#define RSI_BT_Q                     0x2
>> +#define RSI_WLAN_Q                      0x3
>> +#define RSI_WIFI_MGMT_Q                 0x4
>> +#define RSI_WIFI_DATA_Q                 0x5
>> +#define RSI_BT_MGMT_Q                        0x6
>> +#define RSI_BT_DATA_Q                        0x7
>> +
>> +enum rsi_host_intf {
>> +     RSI_HOST_INTF_SDIO = 0,
>> +     RSI_HOST_INTF_USB
>> +};
>> +
>> +#endif
>
> Are you guys ok to have this header file shared by rsi wireless and
> bluetooth driver in include/net?
>

Gentle reminder.

Please share your feedback. So that I can correct this if required.

Regards,
Amitkumar Karwar
