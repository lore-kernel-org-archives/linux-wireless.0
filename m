Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37810 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933806AbbCPQF1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 12:05:27 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [2/3] mwifiex: Add support for auto ARP in mwifiex.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1426145920-5288-2-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20150316160527.4993413FB6D@smtp.codeaurora.org> (sfid-20150316_170531_167331_0CA9B9F3)
Date: Mon, 16 Mar 2015 16:05:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Maithili Hinge <maithili@marvell.com>
> 
> This patch adds support for auto ARP feature in mwifiex.
> The device will respond to ARP requests from the network
> with ARP response in suspended state without waking up the host.
> This feature is enabled in the driver by default.
> 
> Signed-off-by: Maithili Hinge <maithili@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 2 patches applied to wireless-drivers-next.git:

b533be189732 mwifiex: Add support for auto ARP in mwifiex.
6e9344fd8e90 mwifiex: use del_timer variant in interrupt context

Kalle Valo
