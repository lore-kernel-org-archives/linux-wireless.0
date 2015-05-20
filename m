Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.9]:48325 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754638AbbETROc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 13:14:32 -0400
Date: Wed, 20 May 2015 19:14:28 +0200
From: Jakub =?UTF-8?B?S2ljacWEc2tp?= <moorray3@wp.pl>
To: poma <pomidorabelisima@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Felix Fietkau <nbd@openwrt.org>,
	Oleksij Rempel <linux@rempel-privat.de>, kubakici@wp.pl,
	"John W. Linville" <linville@tuxdriver.com>,
	Etna <etna@openmailbox.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: MediaTek WiFi hardware support in upstream kernel
Message-ID: <20150520191428.42e9a3ec@north> (sfid-20150520_191436_339601_1AFC11DA)
In-Reply-To: <555CBEFC.50902@gmail.com>
References: <544DB5A8.7090405@openmailbox.org>
	<20141027152026.GB19976@tuxdriver.com>
	<544E8CB4.3000607@rempel-privat.de>
	<20141028134608.GA26283@tuxdriver.com>
	<544FA303.5060303@broadcom.com>
	<544FA627.3000004@rempel-privat.de>
	<5450BEB2.60208@openwrt.org>
	<5461F937.9060004@rempel-privat.de>
	<5463CB6C.3030204@openwrt.org>
	<5463D28F.9080106@lwfinger.net>
	<20150206182915.7467bac7@north>
	<54EF261E.4040109@gmail.com>
	<20150226154028.380b96f2@north>
	<55592C54.6010204@gmail.com>
	<555CBEFC.50902@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 20 May 2015 19:06:04 +0200, poma wrote:
> With the script 'mt7601u-fw-install' can be initiated the download and installation of the required firmware,
> though it would be optimal to resolve it in the following manner:
> 
> In OpenWrt repo - mt76 - mac80211 driver for MediaTek MT76x2 802.11ac chips
> https://github.com/openwrt/mt76
> 
> there is a license file together with firmwares:
> https://github.com/openwrt/mt76/blob/master/firmware
> 
> 
> Whether the same can be done with:
> mt7601u -  Linux mac80211-based driver for Mediatek MT7601U USB bgn WiFi dongle
> https://github.com/kuba-moo/mt7601u
> ?

I will ask MediaTek to send firmware to linux-firmware.git once the
driver passes review and is accepted to mainline.
