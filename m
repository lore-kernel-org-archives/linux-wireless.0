Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46064 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab0LWH7K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Dec 2010 02:59:10 -0500
Received: by gyb11 with SMTP id 11so2426051gyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 23:59:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1293053386.14423.46.camel@powerslave>
References: <1293028057-6212-1-git-send-email-arik@wizery.com>
 <1293028057-6212-8-git-send-email-arik@wizery.com> <1293053386.14423.46.camel@powerslave>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 23 Dec 2010 09:58:54 +0200
Message-ID: <AANLkTimPRmELJJjRYsw-hjxNDaaPEX5ZHzs6_y7YwVMM@mail.gmail.com>
Subject: Re: [PATCH v2 07/18] wl1271: AP specific RX filter configuration
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 22, 2010 at 23:29, Luciano Coelho <luciano.coelho@nokia.com> wrote:
> On Wed, 2010-12-22 at 16:27 +0200, ext Arik Nemtsov wrote:
>> Set filters according to the mode of operation.
>>
>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>> ---
>
> [...]
>
>> diff --git a/drivers/net/wireless/wl12xx/boot.h b/drivers/net/wireless/wl12xx/boot.h
>> index d67dcff..5f19a40 100644
>> --- a/drivers/net/wireless/wl12xx/boot.h
>> +++ b/drivers/net/wireless/wl12xx/boot.h
>> @@ -69,4 +69,7 @@ struct wl1271_static_data {
>>  #define FREF_CLK_POLARITY_BITS 0xfffff8ff
>>  #define CLK_REQ_OUTN_SEL       0x700
>>
>> +/* Functions from wl1271_main.c */
>> +void wl1271_set_default_filters(struct wl1271 *wl);
>> +
>
> This is not good.  Can't this be defined in rx.c and rx.h instead?

Good point. Will do.

Regards,
Arik
