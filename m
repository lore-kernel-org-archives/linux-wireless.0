Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lugano1.hostireland.com ([72.32.223.205]:48640 "EHLO
	lugano.hostireland.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752052Ab0KLJCd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 04:02:33 -0500
From: "raghunath" <raghunath@airvod.com>
To: "'Levi, Shahar'" <shahar_levi@ti.com>,
	"'Luciano Coelho'" <luciano.coelho@nokia.com>
Cc: <linux-wireless@vger.kernel.org>
References: <004701cb8191$e82c75e0$b88561a0$@com>	 <AANLkTikZD_1DUqkxQyGSLdaQS01Qg15+_TDkW3QuRuOt@mail.gmail.com>	 <1289476604.1606.36.camel@powerslave> <005101cb81af$f1e75280$d5b5f780$@com> <1289488173.1606.58.camel@powerslave> <000001cb822d$067f8230$137e8690$@com> <AC090B9732AB2B4DB7FF476E907FE6600113BB263C@dnce02.ent.ti.com>
In-Reply-To: <AC090B9732AB2B4DB7FF476E907FE6600113BB263C@dnce02.ent.ti.com>
Subject: RE: Ti's WL1271 on OMAP3EVM board with kernel version 2.6.36
Date: Fri, 12 Nov 2010 14:32:29 +0530
Message-ID: <000101cb8248$579d3d90$06d7b8b0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Shahar/Luca,

Its constantly coming, I am building wl1271 sdio driver statically and I am running on OMAP3EVM board from Mistral
And running 2.6.36 kernel and wl1271 sits on MMC2 I have modified code to set PIN MUX and clock for MMC2 and WLAN_EN(GPIO 150)
And WLAN_IRQ(GPIO-149). I am able to download firmare successfully and get Static data from firmware and Chip ID after firmware
Download. With this I am assuming that code I modified for MMC2 on EVM is proper(correct me if I am worng) after that ware is
Failing ,in ELP wake up.

[    2.603698] wl1271: acx ac cfg 1 cw_ming 31 cw_max 1023 aifs 7 txop 0
[    2.603698] wl1271: cmd configure
[    2.604125] wl1271: acx tid config
[    2.604156] wl1271: cmd configure
[    2.604583] wl1271: mac80211 bss info changed
[    2.604644] wl1271: mac80211 configure filter
[    2.604644] wl1271: mac80211 configure filter Airvod 1
[    2.604675] wl1271: acx group address tbl
[    2.604675] wl1271: cmd configure
[    2.605133] wl1271: mac80211 configure filter Airvod 2
[    2.605224] AIRVOD __dev_change_flags   net/core/dev.c ret = 0
[    2.611450] wl1271: elp work
[    2.611480] wl1271: chip to elp
[    2.611541] wl1271: mac80211 configure filter
[    2.611541] wl1271: waking up chip from elp
[    3.108551] wl1271: ERROR ELP wakeup timeout!

Raghu

-----Original Message-----
From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Levi, Shahar
Sent: Friday, November 12, 2010 12:47 PM
To: raghunath; 'Luciano Coelho'
Cc: linux-wireless@vger.kernel.org
Subject: RE: Ti's WL1271 on OMAP3EVM board with kernel version 2.6.36

> -----Original Message-----
> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] On Behalf Of raghunath
> Sent: Friday, November 12, 2010 7:47 AM
> To: 'Luciano Coelho'
> Cc: linux-wireless@vger.kernel.org
> Subject: RE: Ti's WL1271 on OMAP3EVM board with kernel version 2.6.36
> 
> I am using firmware version "wl1271: firmware booted (Rev 6.1.0.0.343)"
> 
> Raghu

do you get it constantly or randomly?
Regards,
Shahar

N�����r��y���b�X��ǧv�^�)޺{.n�+����{��*ޕ�,�{ay�ʇڙ�,j
��f���h���z��w���
���j:+v���w�j�m����
����zZ+�����ݢj"��!

