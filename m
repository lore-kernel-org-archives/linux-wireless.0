Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41869 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbcA2JVL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 04:21:11 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2,1/6] mwifiex: add schedule scan support
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1452677217-21439-2-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	chunfan chen <jeffc@marvell.com>,
	"Amitkumar Karwar" <akarwar@marvell.com>
Message-Id: <20160129092111.0378C6042D@smtp.codeaurora.org> (sfid-20160129_102118_287564_95A95EFA)
Date: Fri, 29 Jan 2016 09:21:10 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Xinming Hu <huxm@marvell.com>
> 
> This patch add sched scan support for mwifiex, include cfg80211
> sched_scan_start/sched_scan_stop handler, corresponding bgscan
> command path and event handler.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: chunfan chen <jeffc@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 6 patches applied to wireless-drivers-next.git:

0c9b7f22e8e1 mwifiex: add schedule scan support
5323b53d80fc mwifiex: add wowlan info messages
7d7f07d8c5d3 mwifiex: add wowlan net-detect support
8de00f1b1c7f mwifiex: report wakeup reason to cfg80211
fdcab083055d mwifiex: add RSSI support for net-detect
a92277bc3bfe mwifiex: use SYNC flag for canceling host sleep

Kalle Valo
