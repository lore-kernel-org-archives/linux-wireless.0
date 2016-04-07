Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52342 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbcDGQnP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 12:43:15 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [RESEND,1/7] mwifiex: add support for GTK rekey offload
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1459843480-25956-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Ganapathi Bhat <gbhat@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160407164314.1E68360269@smtp.codeaurora.org> (sfid-20160407_184319_983337_73339666)
Date: Thu,  7 Apr 2016 16:43:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Ganapathi Bhat <gbhat@marvell.com>
> 
> Added driver functionality to offload GTK rekey to firmware. When
> AP sends new GTK, firmware will update it.
> 
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 7 patches applied to wireless-drivers-next.git:

f6b1cbe029f6 mwifiex: add support for GTK rekey offload
8fa0a0dc634b mwifiex: add support for wakeup on GTK rekey failure
a362e16b83e1 mwifiex: check revision id while choosing PCIe firmware
00c547804968 mwifiex: remove redundant GFP_DMA flag
ad5ca845e3d1 mwifiex: schedule main workqueue for transmitting bridge packets
bf00dc22bc7a mwifiex: AMSDU Rx frame handling in AP mode
4646968b94bd mwifiex: dump pcie scratch registers

Kalle Valo
