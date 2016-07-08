Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40052 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbcGHJ7z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 05:59:55 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/3] mwifiex: code rearrangement in suspend handler
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1467017189-26917-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Wei-Ning Huang <wnhuang@chromium.org>,
	Cathy Luo <cluo@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160708095944.DB01760395@smtp.codeaurora.org> (sfid-20160708_115959_401045_8E38EFE2)
Date: Fri,  8 Jul 2016 09:59:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> We will derive sta_priv at the beginning of suspend handler.
> This will be useful for next patch in this series.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 3 patches applied to wireless-drivers-next.git:

322397b268f7 mwifiex: code rearrangement in suspend handler
09e672a16b92 mwifiex: clear scan_aborting flag
16d25da94f3d mwifiex: fix NULL pointer dereference during suspend

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9200033/

