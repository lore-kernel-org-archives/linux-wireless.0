Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:41766 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbbBJJ1y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2015 04:27:54 -0500
Received: by mail-oi0-f48.google.com with SMTP id a3so9029474oib.7
        for <linux-wireless@vger.kernel.org>; Tue, 10 Feb 2015 01:27:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141204143601.GA6798@redhat.com>
References: <20141129191601.GA1234@kroah.com>
	<CAD-4tLXYVtKJMWYW6cQ9aCL6rusUx3YpWSHys4xcTRN_dJ+kOA@mail.gmail.com>
	<20141130184615.GA3122@kroah.com>
	<CAD-4tLU-3otYOTO98s359z80SSbTJbiSstAYijiU__ekOPJkOA@mail.gmail.com>
	<20141204012407.GA31191@kroah.com>
	<CAD-4tLVrOqiUX2V9_VWMBbnFT-qEsO=zQF4qejd_N2H=scb4aw@mail.gmail.com>
	<20141204043945.GA22144@kroah.com>
	<CAGRGNgXiAAcFoUJyJiC2=yi7LGAU-=6L=NZpJxNj3V4E74RxCw@mail.gmail.com>
	<20141204082348.GA1989@redhat.com>
	<54802031.7010709@rempel-privat.de>
	<20141204143601.GA6798@redhat.com>
Date: Tue, 10 Feb 2015 14:57:53 +0530
Message-ID: <CAD-4tLXy20=a+s7TLnaPrCPMBcw=9n8XFtnbM80E2vpzGfP8Wg@mail.gmail.com> (sfid-20150210_102800_541245_222D3311)
Subject: Re: Ralink 6570 / Mediatek MT7601STA (was Re: Addition of a wifi
 kernel module to the linux source tree)
From: Parth Sane <laerdevstudios@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	Julian Calaby <julian.calaby@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"driverdev-devel@linuxdriverproject.org"
	<driverdev-devel@linuxdriverproject.org>,
	Larry Finger <larry.finger@lwfinger.net>,
	Felix Fietkau <nbd@openwrt.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everone!
A few months earlier I had requested addition of the MT7601 WiFi
dongle module into the kernel. I was told that the needful would be
done in the rt2x00 driver. Could you guys update me with the status?
Thanks a lot!
-Parth Sane

On 4 December 2014 at 20:06, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>
> On Thu, Dec 04, 2014 at 09:49:53AM +0100, Oleksij Rempel wrote:
> > So far i know, Felix is working on abgn+ac (MT7662 and MT7612) devices.
> > MT7601STA is (a)bgn. Are there similar regs?
>
> All Mediatek/Ralink devices I know have the same MAC registers, but
> different BBP and RF registers.
>
> > In mt7601 code i see parts like "if (IS_RT3290(pAd) || IS_RT65XX(pAd) ||
> > IS_MT7601(pAd))".  RT3290 is supported by rt2x00.
>
> Hence looks that support for this devices should be added to rt2x00.
>
> Stanislaw
>
