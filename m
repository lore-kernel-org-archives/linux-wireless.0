Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40186 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbcF2Pya (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 11:54:30 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/6] mwifiex: Fix an issue spotted by KASAN
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1466083346-18607-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Cathy Luo <cluo@marvell.com>,
	Ganapathi Bhat <gbhat@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160629155429.81E2461388@smtp.codeaurora.org> (sfid-20160629_175433_443125_BDED0102)
Date: Wed, 29 Jun 2016 15:54:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> From: Ganapathi Bhat <gbhat@marvell.com>
> 
> When an association command is sent to firmware but the process is
> killed before the command response arrives, driver will try to
> access bss_desc which is already freed. This issue is fixed by
> checking return value of bss_start.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 6 patches applied to wireless-drivers-next.git:

4699fc3f2dcb mwifiex: Fix an issue spotted by KASAN
a9c790ba23eb mwifiex: factor out mwifiex_cancel_scan
dec277f781ce mwifiex: cancel pending scan during disconnect
437322ea2a36 mwifiex: fix system hang problem after resume
568fb26ec8be mwifiex: fix AP unable to start in VHT40 problem
7311ea850079 mwifiex: fix AP start problem for newly added interface

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9180805/

