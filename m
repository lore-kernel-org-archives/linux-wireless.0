Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41045 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbbJNLWe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 07:22:34 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/3] mwifiex: fix AP VHT behaviour
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1444389995-4869-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Ganapathi Bhat <gbhat@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20151014112234.4B7F9141D8E@smtp.codeaurora.org> (sfid-20151014_132242_179252_F97C01D7)
Date: Wed, 14 Oct 2015 11:22:34 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Ganapathi Bhat <gbhat@marvell.com>
> 
> Even if hostapd configuration file contains VHT parameters,
> they were not getting reflected in beacons. The reason is
> we are resetting them before starting AP. This patch removes
> redundant BSS_STOP and SYS_RESET firmware commands before
> starting AP to fix the problem.
> 
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 3 patches applied to wireless-drivers-next.git:

505c5cb82ddf mwifiex: fix AP VHT behaviour
fe24372d1b11 mwifiex: add ndo_validate_addr netdev ops
8785955bbc28 mwifiex: remove unnecessary NULL check

Kalle Valo
