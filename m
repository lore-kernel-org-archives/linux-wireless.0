Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53519 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbcDZJ0O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 05:26:14 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: stop background scan when net device closed
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1460986975-2483-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
	Wei-Ning Huang <wnhuang@chromium.org>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160426092613.C0F4F612EC@smtp.codeaurora.org> (sfid-20160426_112622_151884_15DBDB74)
Date: Tue, 26 Apr 2016 09:26:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Xinming Hu <huxm@marvell.com>
> 
> Transmit data path should not touch background scan. We will stop
> background scan when net device is closed.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
