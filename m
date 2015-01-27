Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:44296 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757384AbbA0RkK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 12:40:10 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2] mwifiex: set netif carrier off in ndo_open
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1421663076-32291-1-git-send-email-patila@marvell.com>
To: Avinash Patil <patila@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Stable <stable@vger.kernel.org>,
	<akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Avinash Patil <patila@marvell.com>
Message-Id: <20150127174009.E8360140B2D@smtp.codeaurora.org> (sfid-20150127_184021_006243_9D2A122C)
Date: Tue, 27 Jan 2015 17:40:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Johannes Berg <johannes@sipsolutions.net>
> 
> This patch adds fix to set carrier state off during ndo_open.
> Carrier should be set to ON when device is ready to send data.
> In case of station/adhoc interface device is able to transfer
> data after successful association/join operation.
> For AP this would be after bss_active event.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Avinash Patil <patila@marvell.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
