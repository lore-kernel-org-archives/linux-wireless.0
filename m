Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbaLDOjZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2014 09:39:25 -0500
Date: Thu, 4 Dec 2014 15:36:02 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Parth Sane <laerdevstudios@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	driverdev-devel@linuxdriverproject.org,
	Larry Finger <larry.finger@lwfinger.net>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: Ralink 6570 / Mediatek MT7601STA (was Re: Addition of a wifi
 kernel module to the linux source tree)
Message-ID: <20141204143601.GA6798@redhat.com> (sfid-20141204_153928_569198_8C8B0AD0)
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54802031.7010709@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 04, 2014 at 09:49:53AM +0100, Oleksij Rempel wrote:
> So far i know, Felix is working on abgn+ac (MT7662 and MT7612) devices.
> MT7601STA is (a)bgn. Are there similar regs?

All Mediatek/Ralink devices I know have the same MAC registers, but
different BBP and RF registers.

> In mt7601 code i see parts like "if (IS_RT3290(pAd) || IS_RT65XX(pAd) ||
> IS_MT7601(pAd))".  RT3290 is supported by rt2x00.

Hence looks that support for this devices should be added to rt2x00.

Stanislaw

