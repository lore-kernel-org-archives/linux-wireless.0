Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43261 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbbCCNoB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 08:44:01 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: do not initialize ext_scan in mwifiex_init_adapter
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1424882741-11937-1-git-send-email-patila@marvell.com>
To: Avinash Patil <patila@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, Avinash Patil <patila@marvell.com>
Message-Id: <20150303134400.78953140C76@smtp.codeaurora.org> (sfid-20150303_144408_877295_AE780FE8)
Date: Tue,  3 Mar 2015 13:44:00 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Features which are device specific are already updated in
> interface specific initialization e.g. register_dev.
> We should not initialize them in mwifiex_init_adapter();
> else this would overwrite earlier settings.
> 
> Signed-off-by: Avinash Patil <patila@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
