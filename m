Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24950 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab3DOMU7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 08:20:59 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <ath10k-devel@qca.qualcomm.com>
Subject: ath10k: mac80211 driver for QCA9880
Date: Mon, 15 Apr 2013 15:20:54 +0300
Message-ID: <87li8k0yu1.fsf@kamboji.qca.qualcomm.com> (sfid-20130415_142103_003969_55258A68)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I just pushed initial version of ath10k, our new driver for QCA9880 &
co, to github.com:

https://github.com/kvalo/ath10k

The driver is pretty small, roughly 14 kLOC. Even if the name implies
that this is an evolution from ath9k, the drivers are actually very
different. The biggest difference is that there's now firmware running
on the chip.

Once ath10k is ready I will send it for proper review. But we are not
quite there yet.

-- 
Kalle Valo
