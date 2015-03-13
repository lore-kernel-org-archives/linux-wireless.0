Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:38847 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbbCMIRT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 04:17:19 -0400
MIME-Version: 1.0
In-Reply-To: <CABxcv=mETO9ESVa04YjRO1d-h5ksEwvwGKb1G-jxVk6ttr9JYg@mail.gmail.com>
References: <1426162154-8716-1-git-send-email-eliad@wizery.com>
	<1426162154-8716-6-git-send-email-eliad@wizery.com>
	<CABxcv=mETO9ESVa04YjRO1d-h5ksEwvwGKb1G-jxVk6ttr9JYg@mail.gmail.com>
Date: Fri, 13 Mar 2015 09:17:18 +0100
Message-ID: <CAFqH_53D52WGDZUTv=w7SguTeROwrzmn9XLB+cTg-3y+Q4FxfQ@mail.gmail.com> (sfid-20150313_092322_463410_E2E8CA35)
Subject: Re: [PATCH v6 5/6] ARM: dts: add wl12xx/wl18xx bindings
From: Enric Balletbo Serra <eballetbo@gmail.com>
To: Javier Martinez Canillas <javier@dowhile0.org>
Cc: Eliad Peller <eliad@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
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
	Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Pau Pajuel <paupa13@gmail.com>,
	=?UTF-8?Q?Agust=C3=AD?= <afontquerni@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

2015-03-13 9:01 GMT+01:00 Javier Martinez Canillas <javier@dowhile0.org>:
> Hello Eliad,
>
> On Thu, Mar 12, 2015 at 1:09 PM, Eliad Peller <eliad@wizery.com> wrote:
>> Replace all the pdata-quirks for setting wl12xx/wl18xx
>> platform data with proper DT definitions.
>>
>> The patch was compile-tested only.
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>
> I wanted to test your series but I realized that the IGEPv2 I've
> access is the old revision that has another SDIO wlan module instead
> of a Wilink8.
>
> Maybe Enric have the new revision? I also added to Pau Pajuel as cc
> who still works in the company manufacturing these boards so he should
> be able to test it.
>

Sorry, now I only have an old revision too, so I can't test, cc'ing
Agustí that has access to the hardware, maybe he can test it or he can
provide to us a board ;)

> But in any case, your patch looks good to me so for the
> arch/arm/boot/dts/omap3-igep00* changes:
>
> Acked-by: Javier Martinez Canillas <javier@dowhile0.org>
>

For my part also looks good.

Acked-by: Enric Balletbo i Serra <eballetbo@gmail.com>

Best regards,
   Enric

> Best regards,
> Javier
