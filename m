Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.sig21.net ([80.244.240.74]:46775 "EHLO mail.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbbLPWBt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 17:01:49 -0500
Date: Wed, 16 Dec 2015 22:24:25 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Jakub =?utf-8?B?S2ljacWEc2tp?= <moorray3@wp.pl>,
	Tuomas =?iso-8859-1?Q?R=E4s=E4nen?= <tuomasjjrasanen@tjjr.fi>,
	linux-wireless@vger.kernel.org, tuomasjjrasanen@opinsys.fi,
	Linus Walleij <linus.walleij@linaro.org>
Subject: Re: About adding support for MT76x2U to Linux kernel
Message-ID: <20151216212425.GA25906@sig21.net> (sfid-20151216_230152_577506_1E44FD65)
References: <20150814081526.GC20192@hackpad.Elisa>
 <20150814143229.61440072@north>
 <5671B310.2080200@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5671B310.2080200@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, Dec 16, 2015 at 07:53:04PM +0100, Felix Fietkau wrote:
> Once I'm done with mt7603 bringup (monitor mode rx already works), I
> plan on submitting mt76 upstream, and then we can see about adding
> support for 76x2u, or even merging the hardware support for mt7601u.
> 
> You can check out my work in the mt7603 branch here:
> https://github.com/openwrt/mt76/tree/mt7603

let me chime in to say that I'm interested to work on
support for mt7610u (TP-LINK Archer T2U/T2UH).
https://wikidevi.com/wiki/TP-LINK_Archer_T2U

I'm facing the same question as Tuomas about using
mt76 or mt7601u as the base?


Johannes
