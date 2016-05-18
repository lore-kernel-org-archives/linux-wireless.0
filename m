Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbcERO51 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2016 10:57:27 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Daniel Lenski <dlenski@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] rtl8xxxu: Increase default polling timeout for firmware startup
References: <1463534086-22353-1-git-send-email-dlenski@gmail.com>
	<1463534086-22353-2-git-send-email-dlenski@gmail.com>
	<wrfja8jo3unl.fsf@redhat.com>
	<CAOw_LSGGVAFpV9NRm3wp1_xNBpk+6ze4=0or+f9a4Dd75U-JEA@mail.gmail.com>
Date: Wed, 18 May 2016 10:57:25 -0400
In-Reply-To: <CAOw_LSGGVAFpV9NRm3wp1_xNBpk+6ze4=0or+f9a4Dd75U-JEA@mail.gmail.com>
	(Daniel Lenski's message of "Tue, 17 May 2016 21:03:50 -0700")
Message-ID: <wrfjy477za5m.fsf@redhat.com> (sfid-20160518_165736_958053_A7F9B30C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Lenski <dlenski@gmail.com> writes:
> On Tue, May 17, 2016 at 8:35 PM, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
>> Dan Lenski <dlenski@gmail.com> writes:
>>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
>>> b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
>>> index f2a1bac..39c6ce7 100644
>>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
>>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
>>> @@ -49,7 +49,7 @@
>>>  #define TX_PAGE_NUM_NORM_PQ          0x02
>>>
>>>  #define RTL_FW_PAGE_SIZE             4096
>>> -#define RTL8XXXU_FIRMWARE_POLL_MAX   1000
>>> +#define RTL8XXXU_FIRMWARE_POLL_MAX   5000
>>
>> This is a long delay - how about 2000?
>
> I tried 2000 first, and it worked for me on only 1 out of 3 cold boots.

OK, lets go for 5000 then to be safe.

Cheers,
Jes
