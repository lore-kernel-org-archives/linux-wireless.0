Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:46908 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbbCKNi5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 09:38:57 -0400
MIME-Version: 1.0
In-Reply-To: <CABxcv==yx3dy-beEF9cf1mKo1vjCh_LU6iLuvn1z-SKz9xG0qA@mail.gmail.com>
References: <1425915402-10012-1-git-send-email-eliad@wizery.com>
	<6286151.8rcX893TN6@wuerfel>
	<CABxcv=mPVxW=BqL2PUL=AtS74kcqMG1yxC1WqMpxGiNOqGAnyQ@mail.gmail.com>
	<2353601.si5uCETVn2@wuerfel>
	<CABxcv==yx3dy-beEF9cf1mKo1vjCh_LU6iLuvn1z-SKz9xG0qA@mail.gmail.com>
Date: Wed, 11 Mar 2015 15:38:56 +0200
Message-ID: <CAB3XZEfi49qMsB7A3p4Y7r9emzSbeyUGVy4-njzey1UnJU0qzA@mail.gmail.com> (sfid-20150311_143902_680946_8EF52477)
Subject: Re: [PATCH v5 3/3] ARM: dts: igep00x0: add wl18xx bindings
From: Eliad Peller <eliad@wizery.com>
To: Javier Martinez Canillas <javier@dowhile0.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Sekhar Nori <nsekhar@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 11, 2015 at 3:21 PM, Javier Martinez Canillas
<javier@dowhile0.org> wrote:
> On Wed, Mar 11, 2015 at 2:17 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Wednesday 11 March 2015 14:07:11 Javier Martinez Canillas wrote:
>>>
>>> Right now it seems that all boards in mainline with a WiLink6 part are
>>> using internal clocks. So as a first step I think that adding an
>>> optional refclock-frequency and tcxoclock-frequency properties should
>>> be enough.
>>>
>>> It would be good if the driver supports getting the refclock and
>>> tcxoclock from an external provider in case a board gets these from
>>> external clocks but that can be done as a followup if there are boards
>>> in the future using that design.
>>>
>>> But please bear in mind that I'm not familiar with the clock handling
>>> in WiLink6 since the WiLink8 part used in the IGEP boards does not
>>> need these clocks and I only looked at Luciano's previous patches and
>>> the WiLink today driver today. So it would be good if Eliad can double
>>> check my assumptions to see if those are correct.
>>
sounds right. that's what i know as well.

>> Sounds good. I'd also be fine with not implementing the case for
>> external clocks in the code until we need (and can test) it, but
>> I think it should be specified in the binding from the start.
>>
> Agreed.
>
great. so i'll implement the internal clocks case only.

thanks,
Eliad.
