Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:59456 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932515AbcI3O7B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Sep 2016 10:59:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v3 1/3] Documentation: dt: net: add mt76 wireless device binding
Date: Fri, 30 Sep 2016 16:58:34 +0200
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20160905095128.80560-1-nbd@nbd.name> <201609301636.43363.arnd@arndb.de> <557be2b8-5ff1-83ea-f6d1-6421c2465969@nbd.name>
In-Reply-To: <557be2b8-5ff1-83ea-f6d1-6421c2465969@nbd.name>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201609301658.35039.arnd@arndb.de> (sfid-20160930_172119_430440_207F6019)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 30 September 2016, Felix Fietkau wrote:
> >> >> >> +                 device_type = "pci";
> >> >> >> +                 mediatek,mtd-eeprom = <&factory 0x8000>;
> >> >> >> +                 mediatek,2ghz = <0>;
> >> > 
> >> > It's not clear what the possible values for the 2ghz property are,
> >> > can you be more verbose in the description? How is <0> different
> >> > from no property?
> >> 0 means disabled, no property means unchanged (compared to EEPROM).
> > 
> > Maybe have a boolean property instead then to say "mediatek,2ghz-disabled" ?
> > 
> > If zero is the only possible value, there is no need to put a number in there.
> 1 is also possible, which will force-enable the capability.

Ok, then both those values should be documented in the binding.

	Arnd
