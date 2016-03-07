Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caladan.dune.hu ([78.24.191.180]:60630 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753339AbcCGVWl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 16:22:41 -0500
Subject: Re: About adding support for MT76x2U to Linux kernel
To: Johannes Stezenbach <js@sig21.net>
References: <20150814081526.GC20192@hackpad.Elisa>
 <20150814143229.61440072@north> <20160302073210.GA31353@lakka.kapsi.fi>
 <20160307111443.GA7205@sig21.net> <56DD6B4F.2050405@openwrt.org>
 <20160307124103.GA22175@sig21.net>
Cc: =?UTF-8?Q?Tuomas_R=c3=a4s=c3=a4nen?= <tuomasjjrasanen@tjjr.fi>,
	=?UTF-8?Q?Jakub_Kici=c5=84ski?= <moorray3@wp.pl>,
	linux-wireless@vger.kernel.org, tuomasjjrasanen@opinsys.fi,
	Linus Walleij <linus.walleij@linaro.org>
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <56DDF11E.3060102@openwrt.org> (sfid-20160307_222245_202524_03185DD8)
Date: Mon, 7 Mar 2016 22:22:38 +0100
MIME-Version: 1.0
In-Reply-To: <20160307124103.GA22175@sig21.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-03-07 13:41, Johannes Stezenbach wrote:
> On Mon, Mar 07, 2016 at 12:51:43PM +0100, Felix Fietkau wrote:
>> On 2016-03-07 12:14, Johannes Stezenbach wrote:
>> > FWIW, the mt7610u vendor driver
>> > doesn't support AP mode, while the mt7612u vendor driver does,
>> > but I didn't understand how their timing of sending buffered
>> > frames works.
>> Where can I find the most recent version of that vendor driver?
>> I can take a quick look at it.
> 
> http://www.mediatek.com/en/downloads1/downloads/
> or more specifically
> http://www.mediatek.com/en/downloads1/downloads/mt7612u/
I checked, they simply use a software timer for it and stuff buffered
multicast packets into the BE queue. I don't think the hardware offers
any better way of doing this...

- Felix
