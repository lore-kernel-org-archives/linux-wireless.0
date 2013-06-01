Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f47.google.com ([209.85.216.47]:46088 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3FASKJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jun 2013 14:10:09 -0400
Received: by mail-qa0-f47.google.com with SMTP id n20so1100178qaj.20
        for <linux-wireless@vger.kernel.org>; Sat, 01 Jun 2013 11:10:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51AA3832.2070605@hauke-m.de>
References: <CA+nFU8T5Ja9jg_E7=Y4TbsT+OxJfNy=x18CMm3VUA9BcKb1+WA@mail.gmail.com>
 <51AA3832.2070605@hauke-m.de>
From: =?ISO-8859-1?Q?Marc_Mar=ED?= <5.markmb.5@gmail.com>
Date: Sat, 1 Jun 2013 20:09:48 +0200
Message-ID: <CA+nFU8TSDVRzHh0GBve8nfXEhqL=k9GvPaJ9LAGqU8gziEqywQ@mail.gmail.com> (sfid-20130601_201012_701364_5B970066)
Subject: Re: Intel Centrino Advanced N 6200 and Debian 7
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is strange, because I bought it on Amazon time ago, and it has been
working on Fedora since then... Well, I sent an email to Intel,
because they offer linux support through email.

Thank you for your answer

2013/6/1 Hauke Mehrtens <hauke@hauke-m.de>:
> On 06/01/2013 07:57 PM, Marc Marí wrote:
>> Hello everyone
>>
>> I recently changed my wireless card from a Broadcom (very bad
>> supported) to a Intel Centrino Advanced N 6200. In Fedora, it works
>> well, but I prefer Debian, and I'll change again, but in a Debian 7
>> live CD (I need my laptop, so I can't stay several days with a half
>> installation) the wifi doesn't work (kernel 3.2.0-4). This is the
>> error
>>
>> Jun  1 17:36:54 localhost kernel: [ 1355.505261] iwlwifi 0000:03:00.0:
>> Unsupported (too old) EEPROM VER=0x416 < 0x423 CALIB=0x5 < 0x4
>
> This looks like you bought an engineering sample and not a device that
> should be sold to end users. This device is not supported and you
> probably have to buy a different one.
>
>> Jun  1 17:36:54 localhost kernel: [ 1355.505393] iwlwifi: probe of
>> 0000:03:00.0 failed with error -22
>>
>> Searching the web, it seems that the error is not very common, but is
>> a weird thing, so I am asking for any support in this.
>>
>> Thank you in advance
>> Marc
>
