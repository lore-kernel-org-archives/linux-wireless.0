Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:55137 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab3IKHTm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Sep 2013 03:19:42 -0400
Received: by mail-ie0-f175.google.com with SMTP id 9so3913193iec.6
        for <linux-wireless@vger.kernel.org>; Wed, 11 Sep 2013 00:19:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1378797585.4799.54.camel@porter.coelho.fi>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
	<1378218848-7853-7-git-send-email-eliad@wizery.com>
	<1378797585.4799.54.camel@porter.coelho.fi>
Date: Wed, 11 Sep 2013 09:19:41 +0200
Message-ID: <CAB3XZEfV1t6pgP1hWz_sSAR66q5ZkGYHDaGVr6yR0k30JSVxjw@mail.gmail.com> (sfid-20130911_091948_323878_C4FFCED8)
Subject: Re: [PATCH 07/12] wlcore: cleanup scan debug prints
From: Eliad Peller <eliad@wizery.com>
To: Luca Coelho <luca@coelho.fi>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 10, 2013 at 10:19 AM, Luca Coelho <luca@coelho.fi> wrote:
> On Tue, 2013-09-03 at 17:34 +0300, Eliad Peller wrote:
>> From: Victor Goldenshtein <victorg@ti.com>
>>
>> Remove scan debug dumps which are rarely used.
>> Make scan debug prints more clear and short.
>>
>> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
> [...]
>> @@ -222,6 +212,18 @@ wlcore_scan_get_channels(struct wl1271 *wl,
>>                                            *n_pactive_ch);
>>                       }
>>
>> +                     wl1271_debug(DEBUG_SCAN, "freq %04d, ch. %03d, flags 0x%02X, power %02d, min/max_dwell %02d/%02d%s%s",
>
> Left-padding with zeros is quite ugly with the decimals here.
>
i agree :)

i'll take care of your comments and resubmit.

thanks,
Eliad.
