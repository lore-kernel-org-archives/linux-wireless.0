Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47578 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbbFBUST (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 16:18:19 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/6] mwifiex: fix SDIO firmware dump problem
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1432647272-5734-2-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20150602201819.4C74F13FFCF@smtp.codeaurora.org> (sfid-20150602_221822_903968_6CFC691F)
Date: Tue,  2 Jun 2015 20:18:19 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> It's been observed that firmware doesn't go back to normal
> state when all firmware memories are dumped. As a result,
> further commands are blocked. This happens due to missing
> driver change of writing READ DONE to control register for
> SDIO interface.
> 
> This patch adds a missing change to fix the problem.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>

Thanks, 6 patches applied to wireless-drivers-next.git:

e065ddb89175 mwifiex: fix SDIO firmware dump problem
0769b27739ee mwifiex: fix a possible double free issue
38b130e22e40 mwifiex: dump driver information for PCIe interface
9cc0dbf04367 mwifiex: minor changes in debug messages
fc697159ad4c mwifiex: use generic name 'device dump'
57670ee882d4 mwifiex: device dump support via devcoredump framework

Kalle Valo
