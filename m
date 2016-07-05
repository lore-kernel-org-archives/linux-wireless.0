Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53881 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbcGENJc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2016 09:09:32 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: [PATCH] mwifiex: fix unconditional error return in .add_virtual_intf callback
References: <1467401982-18943-1-git-send-email-javier@osg.samsung.com>
Date: Tue, 05 Jul 2016 16:09:26 +0300
In-Reply-To: <1467401982-18943-1-git-send-email-javier@osg.samsung.com>
	(Javier Martinez Canillas's message of "Fri, 1 Jul 2016 15:39:42
	-0400")
Message-ID: <87twg42pvd.fsf@kamboji.qca.qualcomm.com> (sfid-20160705_151210_173829_BEBC450E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Javier Martinez Canillas <javier@osg.samsung.com> writes:

> The commit 7311ea850079 ("mwifiex: fix AP start problem for newly added
> interface") attempted to fix an issue when a new AP interface is added.
>
> But the patch didn't check the return value of the functions doing the
> firmware calls and returned an error even if the functions didn't fail.
>
> This prevents the network device to be registered properly, so fix it.
>
> Fixes: commit 7311ea850079 ("mwifiex: fix AP start problem for newly added interface")
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

The fixes line should be:

Fixes: 7311ea850079 ("mwifiex: fix AP start problem for newly added interface")

I can fix that before I apply the patch.

-- 
Kalle Valo
