Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:37719 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbZJQVU6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2009 17:20:58 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 2/2] rt2x00: Implement support for rt2800pci
Date: Sat, 17 Oct 2009 23:18:56 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Alban Browaeys <prahal@yahoo.com>,
	Benoit PAPILLAULT <benoit.papillault@free.fr>,
	Felix Fietkau <nbd@openwrt.org>,
	Luis Correia <luis.f.correia@gmail.com>,
	Mattias Nissler <mattias.nissler@gmx.de>,
	Mark Asselstine <asselsm@gmail.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	"linux-kernel" <linux-kernel@vger.kernel.org>
References: <200910152137.58164.IvDoorn@gmail.com> <200910152204.16407.IvDoorn@gmail.com> <200910171654.03344.bzolnier@gmail.com>
In-Reply-To: <200910171654.03344.bzolnier@gmail.com>
MIME-Version: 1.0
Message-Id: <200910172318.56929.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 17 October 2009 16:54:03 Bartlomiej Zolnierkiewicz wrote:
> 
> [ I somehow missed this one by not being on cc: ]
> 
> On Thursday 15 October 2009 22:04:14 Ivo van Doorn wrote:
> > Add support for the rt2860/rt3090 chipsets from Ralink.
> > 
> > Includes various patches from a lot of people who helped
> > getting this driver into the current shape.
> > 
> > Signed-off-by: Alban Browaeys <prahal@yahoo.com>
> > Signed-off-by: Benoit PAPILLAULT <benoit.papillault@free.fr>
> > Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> > Signed-off-by: Luis Correia <luis.f.correia@gmail.com>
> > Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
> > Signed-off-by: Mark Asselstine <asselsm@gmail.com>
> > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> > ---
> > http://kernel.org/pub/linux/kernel/people/ivd/patches/0003-rt2x00-Implement-support-for-rt2800pci.patch
> 
> First let me say that I'm very happy to see this patch finally being
> submitted and I appreciate the effort..
> 
> (I'll give it a spin on Eee 901 w/ 2.6.32-rc5 sometime later..)

Unfortunately still no luck with it, works just like it worked when I first
tried it half a year ago (loads OK but "iwlist wlan0 scan" doesn't bring any
results)..

Could somebody with the genuine RT2860 revision of the chip try the driver
and confirm that it works w/ 2.6.32-rc5 so I will know whether I should be
looking for some generic problem or RT2880 revision specific one?

Thanks.
