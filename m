Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:39627 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbaI0Khe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Sep 2014 06:37:34 -0400
MIME-Version: 1.0
In-Reply-To: <54267661.5000401@hauke-m.de>
References: <1411741733-13888-1-git-send-email-zajec5@gmail.com>
	<2539898.4te2VKk57a@wuerfel>
	<CACna6rwwfJOdnxhmnW7MUuUC1YBPx8bmDbiaSy1+G39hF4p7OA@mail.gmail.com>
	<54267661.5000401@hauke-m.de>
Date: Sat, 27 Sep 2014 12:37:33 +0200
Message-ID: <CACna6rwYcSh7-uFYA+paNehNwrqddmn2az+a9ZwggVGofbDR7w@mail.gmail.com> (sfid-20140927_123738_524810_67C89EB4)
Subject: Re: [PATCH] bcma: use device from DT (brcm,bus-gpio) for SoC GPIO chip
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	devicetree@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 September 2014 10:33, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> I would make GPIO a subdevive of chipcommon. The chipcommon core has an
> own IRQ which is also used for GPIO.

Which ChipCommon do yo mean?
1) chipcommonA (compatible = "simple-bus")
2) chipcommon@0 (child of axi@18000000 AKA brcm,bus-axi)

It seems that for some reason both of them use IRQ 85, while the IRQ
for ChipCommon is 117 I believe.

-- 
Rafał
