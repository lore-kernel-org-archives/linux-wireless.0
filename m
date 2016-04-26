Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53267 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbcDZJZV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 05:25:21 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v7,1/2] dt: bindings: add MARVELL's sd8xxx wireless device
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1460982143-1419-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <devicetree@vger.kernel.org>,
	Wei-Ning Huang <wnhuang@chromium.org>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160426092520.5889D612F4@smtp.codeaurora.org> (sfid-20160426_112529_178792_F0D07AA6)
Date: Tue, 26 Apr 2016 09:25:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Xinming Hu <huxm@marvell.com>
> 
> Add device tree binding documentation for MARVELL's sd8xxx
> (sd8897 and sd8997) wlan chip.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Acked-by: Rob Herring <robh@kernel.org>

Thanks, 2 patches applied to wireless-drivers-next.git:

84039920bdff dt: bindings: add MARVELL's sd8xxx wireless device
ce4f6f0c353b mwifiex: add platform specific wakeup interrupt support

Kalle Valo
