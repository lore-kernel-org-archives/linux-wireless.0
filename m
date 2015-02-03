Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:34884 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965661AbbBCN3e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 08:29:34 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/4] mwifiex: correction in wakeup timer handling
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1422607207-15229-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20150203132934.12DB8140B4E@smtp.codeaurora.org> (sfid-20150203_142945_078756_406424B6)
Date: Tue,  3 Feb 2015 13:29:34 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Wakeup timer is in sync with 'pm_wakeup_fw_try' flag. It
> has been started instead of cancelling at one place. This
> patch corrects it.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>

Thanks, 4 patches applied to wireless-drivers-next.git:

ee6f0dd8a836 mwifiex: correction in wakeup timer handling
7a1f4e61eb64 mwifiex: fix memory leak in mwifiex_send_processed_packet()
0ea3186ce03c mwifiex: fix NULL packet downloading issues
fc8f0456dcce mwifiex: disable UAPSD mode when AP starts

Kalle Valo
