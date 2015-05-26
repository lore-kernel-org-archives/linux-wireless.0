Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58681 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268AbbEZN5v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 09:57:51 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/4] mwifiex: add support for FW memory read/write operations
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1431371900-7260-1-git-send-email-patila@marvell.com>
To: Avinash Patil <patila@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <liuzy@marvell.com>, <crlo@marvell.com>,
	Avinash Patil <patila@marvell.com>
Message-Id: <20150526105211.A1B321416B3@smtp.codeaurora.org> (sfid-20150526_155803_354624_DB5C5B1F)
Date: Tue, 26 May 2015 10:52:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Chin-ran Lo <crlo@marvell.com>
> 
> This patch adds support for FW memory read/write operations via debugfs.
> This is useful during debugging FW issues.
> 
> Examples:
> 
> For reading FW memory location:
> echo r 0x01ac > /sys/kernel/debug/mwifiex/mlan0/memrw
> cat /sys/kernel/debug/mwifiex/mlan0/memrw
> 
> For writing FW memory location:
> echo w 0x01ac 0x55aa > /sys/kernel/debug/mwifiex/mlan0/memrw
> 
> Signed-off-by: Chin-ran Lo <crlo@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Avinash Patil <patila@marvell.com>

Thanks, 4 patches applied to wireless-drivers-next.git:

c2c6c85fca47 mwifiex: add support for FW memory read/write operations
c687a0077faa mwifiex: add prints debug ctrl support
868093a9df75 mwifiex: add dump data debug support
acebe8c10a6e mwifiex: change dbg print func to mwifiex_dbg

Kalle Valo
