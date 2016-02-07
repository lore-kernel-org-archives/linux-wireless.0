Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41107 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbcBGHQS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2016 02:16:18 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/8] mwifiex: display right transmit packet delay
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1454479509-27129-2-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160207071617.E49BF6047C@smtp.codeaurora.org> (sfid-20160207_081621_541884_F9F6FCA1)
Date: Sun,  7 Feb 2016 07:16:17 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Xinming Hu <huxm@marvell.com>
> 
> drv_pkt_delay_max should be assigned non-zero value, so that
> packet delay can be accumulate in the right way.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 8 patches applied to wireless-drivers-next.git:

6970cd446c25 mwifiex: display right transmit packet delay
af05148392f5 mwifiex: process pcie io memory read failure case
0172404d79ec mwifiex: skip firmware dump when read_regs() fails
9a86232213b9 mwifiex: keep original structure in decl header file
50632092dfda mwifiex: use an extensible framework for firmware dump solution
56486026c282 mwifiex: dynamically increase preallocated firmware dump memory size
03f0f7cdebeb mwifiex: increase the priority of firmware dump message
11e70824e75f mwifiex: firmware dump support for w8997 chipset

Kalle Valo
