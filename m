Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:42733 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbbAFTVT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 14:21:19 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Maithili Hinge <maithili@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Marc Yang <yangyang@marvell.com>
Subject: Re: [PATCH 0/9] mwifiex enhancements
References: <1420022206-11435-1-git-send-email-akarwar@marvell.com>
Date: Tue, 06 Jan 2015 21:21:11 +0200
In-Reply-To: <1420022206-11435-1-git-send-email-akarwar@marvell.com>
	(Amitkumar Karwar's message of "Wed, 31 Dec 2014 02:36:37 -0800")
Message-ID: <87k30zww9k.fsf@kamboji.qca.qualcomm.com> (sfid-20150106_202127_698551_B1B888FF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

> This patch series adds couple of fixes, recovery mechanism
> when host fails to wakeup the firmware and wowlan disconnect
> feature.
>
> Amitkumar Karwar (5):
>   mwifiex: remove redundant flag MWIFIEX_HW_STATUS_FW_READY
>   mwifiex: add wakeup timer based recovery mechanism
>   mwifiex: wakeup pending wait queues
>   mwifiex: do not release lock during list_for_each_entry_safe()
>   mwifiex: Increase priority of firmware download message
>
> Maithili Hinge (2):
>   mwifiex: Move code for wowlan magic-packet and patterns to a function
>   mwifiex: Add support for wowlan disconnect
>
> Marc Yang (2):
>   Adjust calling place of mwifiex_terminate_workqueue
>   mwifiex: increase delay during card reset

Thanks, all patches applied to wireless-drivers-next.git.

-- 
Kalle Valo
