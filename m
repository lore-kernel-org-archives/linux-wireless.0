Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35043 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbcGEObM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2016 10:31:12 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: disable MSIx interrupt for 8997 chipset
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1466499752-1818-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Wei-Ning Huang <wnhuang@chromium.org>,
	Cathy Luo <cluo@marvell.com>, Shengzhen Li <szli@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160705143111.A7028611DD@smtp.codeaurora.org> (sfid-20160705_163115_778181_70AC15DF)
Date: Tue,  5 Jul 2016 14:31:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> From: Shengzhen Li <szli@marvell.com>
> 
> Sometimes MSIx interrupts are received out of order on multi-core
> system. This creates a problem when there is a race between data
> packet and SLEEP event from firmware. We will disable MSIx interrupt
> mode to solve the problem and go with MSI mode.
> 
> Signed-off-by: Shengzhen Li <szli@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

bf942091678c mwifiex: disable MSIx interrupt for 8997 chipset

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9190001/

