Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:34324 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbbCKL7L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 07:59:11 -0400
MIME-Version: 1.0
In-Reply-To: <CABxcv=kUwU2KVw5jYryh62v5us2-CiJFMnYN2nyWLRMWnEkU3w@mail.gmail.com>
References: <1425915402-10012-1-git-send-email-eliad@wizery.com>
	<1425915402-10012-3-git-send-email-eliad@wizery.com>
	<CABxcv=kL3Hw43VVxAsZ=DnY4Z+5431PO2YehcK2zTkFGBG0cNA@mail.gmail.com>
	<CABxcv=kUwU2KVw5jYryh62v5us2-CiJFMnYN2nyWLRMWnEkU3w@mail.gmail.com>
Date: Wed, 11 Mar 2015 13:59:10 +0200
Message-ID: <CAB3XZEdbVgOGH_uz4BX+8NXEu_vZzd=JF_1qvSPbyvvc0-O9iA@mail.gmail.com> (sfid-20150311_125917_138488_CAEAF417)
Subject: Re: [PATCH v5 3/3] ARM: dts: igep00x0: add wl18xx bindings
From: Eliad Peller <eliad@wizery.com>
To: Javier Martinez Canillas <javier@dowhile0.org>
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

hi Javier,

On Wed, Mar 11, 2015 at 3:19 AM, Javier Martinez Canillas
<javier@dowhile0.org> wrote:
> Hello Eliad,
>
> On Wed, Mar 11, 2015 at 1:28 AM, Javier Martinez Canillas
> <javier@dowhile0.org> wrote:
>> On Mon, Mar 9, 2015 at 4:36 PM, Eliad Peller <eliad@wizery.com> wrote:
>>> --- a/arch/arm/boot/dts/omap3-igep0020-rev-f.dts
>>> +++ b/arch/arm/boot/dts/omap3-igep0020-rev-f.dts
>>> @@ -42,4 +42,13 @@
>>>         vmmc-supply = <&lbep5clwmc_wlen>;
>
> Something I forgot to mention is that this vmmc-supply is a DT hack
> since the WLAN SDIO chip needs a WL_EN signal to be asserted as a part
> of the chip power sequencing.
>
> But there wasn't a DT binding to describe that so most boards use the
> same hack which is to define a fake fixed-regulator with an enable
> GPIO just to toggle that pin.
>
> But now the MMC subsystem has support for power sequence providers and
> the pwrseq-simple driver
> (Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt) has
> support for reset GPIOs so you may want to change that as well.
>
interesting. i wasn't aware of it.
but that's for a different time i guess :)

thanks,
Eliad.
