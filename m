Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55629 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbbHMMfY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 08:35:24 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v3,1/3] mwifiex: add support for 8997 chipset
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1438780182-19320-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Zhaoyang Liu <liuzy@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20150813123524.1F31514056F@smtp.codeaurora.org> (sfid-20150813_143528_069320_13B3FBB7)
Date: Thu, 13 Aug 2015 12:35:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Zhaoyang Liu <liuzy@marvell.com>
> 
> This patch adds support for 8997 chipset to mwifiex
> with SDIO/PCIe/USB interface.
> 
> The corresponding firmware image files are located in:
> "mrvl/sd8997_uapsta.bin"
> "mrvl/pcie8997_uapsta.bin"
> "mrvl/usb8997_uapsta.bin"
> 
> Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 3 patches applied to wireless-drivers-next.git:

6d85ef00d9df mwifiex: add support for 8997 chipset
eee7f1961b9d mwifiex: add firmware dump support for SD8997
2375fa2b36fe mwifiex: fix unable to connect hidden SSID AP on DFS channel

Kalle Valo
