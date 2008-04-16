Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.251]:56550 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbYDPDH0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 23:07:26 -0400
Received: by hs-out-0708.google.com with SMTP id 4so947566hsl.5
        for <linux-wireless@vger.kernel.org>; Tue, 15 Apr 2008 20:07:24 -0700 (PDT)
Message-ID: <43e72e890804152007k4e9daea6jb1cb6da11ca89e1f@mail.gmail.com> (sfid-20080416_040811_075116_0ED6DB0D)
Date: Tue, 15 Apr 2008 20:07:24 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: Latest compat-wireless build fails
Cc: "Brian Morrison" <bdm@fenrir.org.uk>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1208176113.522.4.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080412012305.76f1b7eb@fangio.fenrir.org.uk>
	 <20080412104207.478f9f14@fangio.fenrir.org.uk>
	 <1208138233.5319.36.camel@dv>
	 <20080414085918.5116823b@peterson.fenrir.org.uk>
	 <1208176113.522.4.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 14, 2008 at 5:28 AM, Pavel Roskin <proski@gnu.org> wrote:
> On Mon, 2008-04-14 at 08:59 +0100, Brian Morrison wrote:
>
>  > > blink_set is defined in include/linux/led.h in the wireless-testing
>  > > kernel.  I assume it's missing in the kernel you are using.
>  > >
>  >
>  > Looks like it isn't, so possibly there needs to be a way of providing
>  > missing headers for kernels without their own complete set. Not sure
>  > how
>  > that might be done.
>
>  I'm leaving it to Luis.  Most drivers do something with the LEDs, but
>  only rt2x00 uses the new interface.  Either CONFIG_RT2500PCI_LEDS and
>  CONFIG_RT2500USB_LEDS should be explicitly disabled (I guess they are
>  enabled in your kernel), or the drivers should be patched, or the latest
>  LED code should be backported to the older kernels.

I'm sorry I've been a bit busy lately moving myself to the West coast,
but today I managed to start catching up. I've updated compat-wireless
to reflect the latest changes and tested a build and load. Please give
it a run and let me know if you still have issues. I'd like to address
them if still present.

  Luis
