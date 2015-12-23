Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:33715 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbbLWPFI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2015 10:05:08 -0500
Received: by mail-wm0-f45.google.com with SMTP id p187so148285084wmp.0
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2015 07:05:07 -0800 (PST)
Subject: Re: MediaTek WiFi hardware support in upstream kernel
To: =?UTF-8?Q?Jakub_Kici=c5=84ski?= <moorray3@wp.pl>
References: <544DB5A8.7090405@openmailbox.org>
 <20141027152026.GB19976@tuxdriver.com> <544E8CB4.3000607@rempel-privat.de>
 <20141028134608.GA26283@tuxdriver.com> <544FA303.5060303@broadcom.com>
 <544FA627.3000004@rempel-privat.de> <5450BEB2.60208@openwrt.org>
 <5461F937.9060004@rempel-privat.de> <5463CB6C.3030204@openwrt.org>
 <5463D28F.9080106@lwfinger.net> <20150206182915.7467bac7@north>
 <54EF261E.4040109@gmail.com> <20150226154028.380b96f2@north>
 <55592C54.6010204@gmail.com> <555CBEFC.50902@gmail.com>
 <20150520191428.42e9a3ec@north> <555DDFB7.9060705@gmail.com>
 <558F0B68.6030007@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Felix Fietkau <nbd@openwrt.org>,
	Oleksij Rempel <linux@rempel-privat.de>, kubakici@wp.pl,
	"John W. Linville" <linville@tuxdriver.com>,
	Etna <etna@openmailbox.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	Hua Shao <hua.shao@mediatek.com>,
	Jay Hung <jay.hung@mediatek.com>
From: poma <pomidorabelisima@gmail.com>
Message-ID: <567AB81E.20302@gmail.com> (sfid-20151223_160513_821755_281D0D6D)
Date: Wed, 23 Dec 2015 16:05:02 +0100
MIME-Version: 1.0
In-Reply-To: <558F0B68.6030007@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27.06.2015 22:45, poma wrote:
> 
> mt7601u landed in 'linux-next'
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/log/drivers/net/wireless/mediatek/mt7601u
> 
> the v4.2 kernel is predicted for Sunday, 2015-08-23
> http://phb-crystal-ball.org
> 
> For the firmware(mt7601u.bin) as part of the essential functionality of the device
> it would be good to land in 'linux-firmware' *even* before the actual kernel release v4.2
> http://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/tree
> 
> 
> tempus fugit
> 


Add firmware for mt7601u. version 34.
http://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/commit/?id=9df5430

Thanks Hua Shao for the firmware,
and of course,
thanks Jakub Kiciński for the driver.

Oh yeah!


