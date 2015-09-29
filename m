Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36705 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592AbbI2Htd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2015 03:49:33 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [01/16] mwifiex: fix typo in del_virtual_intf() function
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1442583138-2979-2-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20150929074933.01843140F48@smtp.codeaurora.org> (sfid-20150929_094936_787968_9F1F8854)
Date: Tue, 29 Sep 2015 07:49:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Xinming Hu <huxm@marvell.com>
> 
> Interface counters should be incremented in add_virtual_intf()
> and decremented in del_virtual_intf() function. This patch
> corrects it.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 16 patches applied to wireless-drivers-next.git:

65405c51bb2e mwifiex: fix typo in del_virtual_intf() function
0a252abb6ad7 mwifiex: update amsdu tx packet time stamp
e3ad3d5b6ab2 mwifiex: minor corrections in multiport aggregation code
9a9053c3420f mwifiex: fix driver init failure under memory pressure
02421dd3f6af mwifiex: NULL check for cfg80211_inform_bss()
2c3da961268f mwifiex: don't always include ht/vht info in tdls confirm frame
17e524b1b60f mwifiex: fix NULL pointer dereference during hidden SSID scan
14d9c11c91a6 mwifiex: avoid memsetting PCIe event buffer
70c5ad7e20c1 mwifiex: correct paused tx data packet counter
17090beec26e mwifiex: Suppress -ENOSR error for data traffic on USB
d22871db0172 mwifiex: fix tx data_sent issue for usb interface
d941444321f6 mwifiex: move usb specific data_sent update to usb.c
2b0f997db43f mwifiex: add usb multi channel event process support
308fe29ef243 mwifiex: add usb tx data multi endpoints support
7e4e5d2cd081 mwifiex: add usb multi endpoints resync support
735ab6bfc038 mwifiex: complete usb tx data with multi endpoints

Kalle Valo
