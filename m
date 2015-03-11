Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33212 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbbCKMHp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 08:07:45 -0400
Received: by widfb4 with SMTP id fb4so26484846wid.0
        for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2015 05:07:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB3XZEdbVgOGH_uz4BX+8NXEu_vZzd=JF_1qvSPbyvvc0-O9iA@mail.gmail.com>
References: <1425915402-10012-1-git-send-email-eliad@wizery.com>
	<1425915402-10012-3-git-send-email-eliad@wizery.com>
	<CABxcv=kL3Hw43VVxAsZ=DnY4Z+5431PO2YehcK2zTkFGBG0cNA@mail.gmail.com>
	<CABxcv=kUwU2KVw5jYryh62v5us2-CiJFMnYN2nyWLRMWnEkU3w@mail.gmail.com>
	<CAB3XZEdbVgOGH_uz4BX+8NXEu_vZzd=JF_1qvSPbyvvc0-O9iA@mail.gmail.com>
Date: Wed, 11 Mar 2015 13:07:43 +0100
Message-ID: <CABxcv=ntLn-Hv+J5fdjS6=R+8KYfm+1+4fXmMDQvw-kqFJD3-A@mail.gmail.com> (sfid-20150311_130750_202136_9B96CA22)
Subject: Re: [PATCH v5 3/3] ARM: dts: igep00x0: add wl18xx bindings
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Eliad Peller <eliad@wizery.com>
Cc: Enric Balletbo Serra <eballetbo@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Eliad,

On Wed, Mar 11, 2015 at 12:59 PM, Eliad Peller <eliad@wizery.com> wrote:
> On Wed, Mar 11, 2015 at 3:19 AM, Javier Martinez Canillas
> <javier@dowhile0.org> wrote:
>>
>> But there wasn't a DT binding to describe that so most boards use the
>> same hack which is to define a fake fixed-regulator with an enable
>> GPIO just to toggle that pin.
>>
>> But now the MMC subsystem has support for power sequence providers and
>> the pwrseq-simple driver
>> (Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt) has
>> support for reset GPIOs so you may want to change that as well.
>>
> interesting. i wasn't aware of it.
> but that's for a different time i guess :)
>

Indeed, I've on my TODO anyways so I can post a patch on top of your series :-)

> thanks,
> Eliad.

Best regards,
Javier
