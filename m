Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:37184 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbbCSOm6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2015 10:42:58 -0400
MIME-Version: 1.0
In-Reply-To: <550AD7C1.2030405@gmail.com>
References: <1426696710-6891-1-git-send-email-eliad@wizery.com>
	<1426696710-6891-6-git-send-email-eliad@wizery.com>
	<550AD7C1.2030405@gmail.com>
Date: Thu, 19 Mar 2015 16:42:57 +0200
Message-ID: <CAB3XZEfpD7YkwdU7OJJaNFy=MnYVY3-fOVxkA48Vu01LzU0GFg@mail.gmail.com> (sfid-20150319_154304_228782_48672DE0)
Subject: Re: [PATCH v7 5/6] ARM: dts: add wl12xx/wl18xx bindings
From: Eliad Peller <eliad@wizery.com>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	=?UTF-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
	Tony Lindgren <tony@atomide.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Javier Martinez Canillas <javier@dowhile0.org>,
	Sekhar Nori <nsekhar@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Pontus,

On Thu, Mar 19, 2015 at 4:05 PM, Pontus Fuchs <pontus.fuchs@gmail.com> wrote:
> On 2015-03-18 17:38, Eliad Peller wrote:
>>
>> Replace all the pdata-quirks for setting wl12xx/wl18xx
>> platform data with proper DT definitions.
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> Acked-by: Javier Martinez Canillas <javier@dowhile0.org>
>> Acked-by: Enric Balletbo i Serra <eballetbo@gmail.com>
>> Tested-by: Tony Lindgren <tony@atomide.com>
>> ---
>> v7: rebase
>>
>>   arch/arm/boot/dts/am335x-evmsk.dts             | 11 ++++
>>   arch/arm/boot/dts/omap3-cm-t3517.dts           | 10 ++++
>>   arch/arm/boot/dts/omap3-cm-t3730.dts           | 10 ++++
>>   arch/arm/boot/dts/omap3-evm-common.dtsi        | 10 ++++
>>   arch/arm/boot/dts/omap3-igep0020-rev-f.dts     |  9 ++++
>>   arch/arm/boot/dts/omap3-igep0030-rev-g.dts     |  9 ++++
>>   arch/arm/boot/dts/omap3-zoom3.dts              | 10 ++++
>>   arch/arm/boot/dts/omap4-panda-common.dtsi      | 10 ++++
>
>
> Hi Eliad,
>
> Tested OK (boot, scan, join, ping) on Pandaboard ES.
>
thanks for testing it!

Eliad.
