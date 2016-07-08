Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30761 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345AbcGHOCM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 10:02:12 -0400
Cc: <ath9k-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	<ath9k-devel@lists.ath9k.org>, <nbd@nbd.name>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/6] ath9k: Allow configuration of LED polarity in platform data.
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20160623145714.20576-2-martin.blumenstingl@googlemail.com>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Message-ID: <a146f016c6fd45508e51693db087feb4@euamsexm01a.eu.qualcomm.com> (sfid-20160708_160216_280421_10FF792D)
Date: Fri, 8 Jul 2016 16:01:55 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Martin Blumenstingl <martin.blumenstingl@googlemail.com> wrote:
> Some devices running OpenWrt need this and it makes sense to add this
> to ath9k_platform_data as the next patches will add a devicetree
> (boolean) property for it as well.
> 
> Suggested-by: Vittorio Gambaletta <openwrt@vittgam.net>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Thanks, 5 patches applied to ath-next branch of ath.git:

3467f0d43301 ath9k: Allow configuration of LED polarity in platform data.
b27301f86cc7 ath9k: remove variable which is set but never read
0cefa9749883 ath9k: ath9k_hw_init_macaddr should not overwrite valid MAC addresses
d323cb71abef ath9k: remove return value from ath9k_hw_init_macaddr
28755b8f6d94 ath9k: move all ath9k_platform_data initialization into one function

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9195397/

