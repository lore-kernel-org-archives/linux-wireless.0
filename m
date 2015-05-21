Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:32903 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751AbbEUNiE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 09:38:04 -0400
Received: by wicmx19 with SMTP id mx19so13295209wic.0
        for <linux-wireless@vger.kernel.org>; Thu, 21 May 2015 06:38:03 -0700 (PDT)
Message-ID: <555DDFB7.9060705@gmail.com> (sfid-20150521_153809_660840_75B917E1)
Date: Thu, 21 May 2015 15:37:59 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: =?UTF-8?B?SmFrdWIgS2ljacWEc2tp?= <moorray3@wp.pl>
CC: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Felix Fietkau <nbd@openwrt.org>,
	Oleksij Rempel <linux@rempel-privat.de>, kubakici@wp.pl,
	"John W. Linville" <linville@tuxdriver.com>,
	Etna <etna@openmailbox.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: MediaTek WiFi hardware support in upstream kernel
References: <544DB5A8.7090405@openmailbox.org>	<20141027152026.GB19976@tuxdriver.com>	<544E8CB4.3000607@rempel-privat.de>	<20141028134608.GA26283@tuxdriver.com>	<544FA303.5060303@broadcom.com>	<544FA627.3000004@rempel-privat.de>	<5450BEB2.60208@openwrt.org>	<5461F937.9060004@rempel-privat.de>	<5463CB6C.3030204@openwrt.org>	<5463D28F.9080106@lwfinger.net>	<20150206182915.7467bac7@north>	<54EF261E.4040109@gmail.com>	<20150226154028.380b96f2@north>	<55592C54.6010204@gmail.com>	<555CBEFC.50902@gmail.com> <20150520191428.42e9a3ec@north>
In-Reply-To: <20150520191428.42e9a3ec@north>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20.05.2015 19:14, Jakub Kiciński wrote:
> On Wed, 20 May 2015 19:06:04 +0200, poma wrote:
>> With the script 'mt7601u-fw-install' can be initiated the download and installation of the required firmware,
>> though it would be optimal to resolve it in the following manner:
>>
>> In OpenWrt repo - mt76 - mac80211 driver for MediaTek MT76x2 802.11ac chips
>> https://github.com/openwrt/mt76
>>
>> there is a license file together with firmwares:
>> https://github.com/openwrt/mt76/blob/master/firmware
>>
>>
>> Whether the same can be done with:
>> mt7601u -  Linux mac80211-based driver for Mediatek MT7601U USB bgn WiFi dongle
>> https://github.com/kuba-moo/mt7601u
>> ?
> 
> I will ask MediaTek to send firmware to linux-firmware.git once the
> driver passes review and is accepted to mainline.
> 

Yeah, the foundation is already there:
linux-firmware: Add firmware files for mtk mt7630/mt7650 chipsets
http://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/commit/?id=8267525

Good luck.


