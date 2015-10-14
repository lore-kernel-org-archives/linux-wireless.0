Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40812 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbbJNLV6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 07:21:58 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2] mwifiex: control WLAN and bluetooth coexistence modes
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1444389983-4827-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20151014112158.206DE141D31@smtp.codeaurora.org> (sfid-20151014_132205_008907_751A9661)
Date: Wed, 14 Oct 2015 11:21:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> By default our chip will be in spatial coexistence mode.
> This patch adds a provision to change it to timeshare mode
> via debugfs command.
> 
> Enable timeshare coexistence mode
>    echo 1 > /sys/kernel/debug/mwifiex/mlan0/timeshare_coex
> 
> Go back to spacial coexistence mode
>    echo 0 > /sys/kernel/debug/mwifiex/mlan0/timeshare_coex
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
