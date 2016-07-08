Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57013 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566AbcGHNoT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 09:44:19 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: fix scan_block flag handling
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1467201760-12204-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Wei-Ning Huang <wnhuang@chromium.org>,
	Cathy Luo <cluo@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Xinming Hu <huxm@marvell.com>
Message-Id: <20160708134418.DBC28611F2@smtp.codeaurora.org> (sfid-20160708_154435_121087_72E86706)
Date: Fri,  8 Jul 2016 13:44:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> scan_block flag is used to block scan operation when 4 way handshake
> is in progress. Sometimes it doesn't get cleared due to incomplete
> association. An example is assoc request/response is done, but add key
> operation get canceled in some corner cases. As a result, further
> association/scan operations are blocked.
> 
> This patch fixes the problem by clearing scan_block flag.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Xinming Hu <huxm@marvell.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

b74d6e740be3 mwifiex: fix scan_block flag handling

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9205005/

