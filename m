Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40216 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbbJNLOl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 07:14:41 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/2] mwifiex: remove USB8897 chipset support
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1441895254-28890-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Cathy Luo <cluo@marvell.com>
Message-Id: <20151014111441.5E9C6141C4F@smtp.codeaurora.org> (sfid-20151014_131444_670101_B306D052)
Date: Wed, 14 Oct 2015 11:14:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> We don't have any customer using this chipset via USB
> interface. if both mwifiex_pcie and mwifiex_usb modules
> are enabled by user, sometimes mwifiex_usb wins the race
> even if user wants wlan interface to be on PCIe and
> USB for bluetooth. This patch solves the problem.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Frank Huang <frankh@marvell.com>
> Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>

Thanks, 2 patches applied to wireless-drivers-next.git:

60a188a2715f mwifiex: remove USB8897 chipset support
ce03966a16b0 mwifiex: correction in USB8997 chipset's product ID

Kalle Valo
