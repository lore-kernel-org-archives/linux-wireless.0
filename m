Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33544 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbcEREEb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2016 00:04:31 -0400
Received: by mail-wm0-f65.google.com with SMTP id r12so9526633wme.0
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2016 21:04:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <wrfja8jo3unl.fsf@redhat.com>
References: <1463534086-22353-1-git-send-email-dlenski@gmail.com>
 <1463534086-22353-2-git-send-email-dlenski@gmail.com> <wrfja8jo3unl.fsf@redhat.com>
From: Daniel Lenski <dlenski@gmail.com>
Date: Tue, 17 May 2016 21:03:50 -0700
Message-ID: <CAOw_LSGGVAFpV9NRm3wp1_xNBpk+6ze4=0or+f9a4Dd75U-JEA@mail.gmail.com> (sfid-20160518_060435_288945_786F7CFC)
Subject: Re: [PATCH 1/2] rtl8xxxu: Increase default polling timeout for
 firmware startup
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 17, 2016 at 8:35 PM, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> Dan Lenski <dlenski@gmail.com> writes:
>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
>> b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
>> index f2a1bac..39c6ce7 100644
>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
>> @@ -49,7 +49,7 @@
>>  #define TX_PAGE_NUM_NORM_PQ          0x02
>>
>>  #define RTL_FW_PAGE_SIZE             4096
>> -#define RTL8XXXU_FIRMWARE_POLL_MAX   1000
>> +#define RTL8XXXU_FIRMWARE_POLL_MAX   5000
>
> This is a long delay - how about 2000?

I tried 2000 first, and it worked for me on only 1 out of 3 cold boots.

Dan
