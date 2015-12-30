Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40853 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbbL3PcP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 10:32:15 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/4] mwifiex: fix potential integer truncation
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1450268505-2682-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	chunfan chen <jeffc@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20151230153214.ADD3260345@smtp.codeaurora.org> (sfid-20151230_163218_437630_ECC51AE8)
Date: Wed, 30 Dec 2015 15:32:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: chunfan chen <jeffc@marvell.com>
> 
> At some places, ie length is truncated from u16 to u8 while
> storing it to driver's internal variable. This patch fixes
> the problem.
> 
> Signed-off-by: chunfan chen <jeffc@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 4 patches applied to wireless-drivers-next.git:

1d8f5c138540 mwifiex: fix potential integer truncation
ce0c58d99841 mwifiex: fix PCIe register information for 8997 chipset
f3b35f280968 mwifiex: add missing check for PCIe8997 chipset
7be0f5b5e169 mwifiex: enable MSI interrupt support in pcie

Kalle Valo
