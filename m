Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:45856 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbbCMIBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 04:01:10 -0400
Received: by wesu56 with SMTP id u56so21446148wes.12
        for <linux-wireless@vger.kernel.org>; Fri, 13 Mar 2015 01:01:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1426162154-8716-6-git-send-email-eliad@wizery.com>
References: <1426162154-8716-1-git-send-email-eliad@wizery.com>
	<1426162154-8716-6-git-send-email-eliad@wizery.com>
Date: Fri, 13 Mar 2015 09:01:08 +0100
Message-ID: <CABxcv=mETO9ESVa04YjRO1d-h5ksEwvwGKb1G-jxVk6ttr9JYg@mail.gmail.com> (sfid-20150313_090130_471783_DE3B8A1F)
Subject: Re: [PATCH v6 5/6] ARM: dts: add wl12xx/wl18xx bindings
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Eliad Peller <eliad@wizery.com>
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
	Sekhar Nori <nsekhar@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>, paupa13@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Eliad,

On Thu, Mar 12, 2015 at 1:09 PM, Eliad Peller <eliad@wizery.com> wrote:
> Replace all the pdata-quirks for setting wl12xx/wl18xx
> platform data with proper DT definitions.
>
> The patch was compile-tested only.
>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

I wanted to test your series but I realized that the IGEPv2 I've
access is the old revision that has another SDIO wlan module instead
of a Wilink8.

Maybe Enric have the new revision? I also added to Pau Pajuel as cc
who still works in the company manufacturing these boards so he should
be able to test it.

But in any case, your patch looks good to me so for the
arch/arm/boot/dts/omap3-igep00* changes:

Acked-by: Javier Martinez Canillas <javier@dowhile0.org>

Best regards,
Javier
