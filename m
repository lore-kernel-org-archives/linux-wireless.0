Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:48432 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759279AbbA0SSe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 13:18:34 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2,1/3] mwifiex: add support for SD8801
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1422013159-3093-1-git-send-email-patila@marvell.com>
To: Avinash Patil <patila@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <yogeshp@marvell.com>, <nishants@marvell.com>,
	<frankh@marvell.com>, Avinash Patil <patila@marvell.com>
Message-Id: <20150127181833.A529A14117D@smtp.codeaurora.org> (sfid-20150127_191840_358650_57C33DA4)
Date: Tue, 27 Jan 2015 18:18:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Yogesh Ashok Powar <yogeshp@marvell.com>
> 
> SD8801 is Marvell's 1x1 802.11bgn offering.
> This patch adds Device IDs for SD8801 and also defines card
> structure which has definition for register offsets, buffer sizes etc.
> 
> Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
> Signed-off-by: Avinash Patil <patila@marvell.com>
> Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Frank Huang <frankh@marvell.com>
> Reviewed-by: James Cameron <quozl@laptop.org>

Thanks, 3 patches applied to wireless-drivers-next.git:

52bd3d2023d4 mwifiex: add support for SD8801
eaa3d9fa08c5 mwifiex: add support for USB8801
1fe192d8d63f mwifiex: selectively choose ext_scan support

Kalle Valo
