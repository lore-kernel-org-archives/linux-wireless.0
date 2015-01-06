Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:41076 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbbAFS5K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 13:57:10 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Avinash Patil <patila@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <yangyang@marvell.com>, <huxm@marvell.com>
Subject: Re: [PATCH 0/8] mwifiex debug enhancements
References: <1419342252-2702-1-git-send-email-patila@marvell.com>
Date: Tue, 06 Jan 2015 20:57:03 +0200
In-Reply-To: <1419342252-2702-1-git-send-email-patila@marvell.com> (Avinash
	Patil's message of "Tue, 23 Dec 2014 19:14:04 +0530")
Message-ID: <877fwzyby8.fsf@kamboji.qca.qualcomm.com> (sfid-20150106_195714_417342_1E9661D3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avinash Patil <patila@marvell.com> writes:

> This patch series adds debug enhancements for mwifiex driver.
> Patch series includes patches to dump SDIO function registers/scratch
> registers upon FW crash, histogram support, adapter structure dump,
> TDLS peer information via debugfs.
> Also a patch to control auto deepsleep via module load parameter is added.

Thanks. This overview of changes was very good, please continue
including that in the future as well

> Avinash Patil (1):
>   mwifiex: module parameter for deep sleep configuration
>
> Xinming Hu (7):
>   mwifiex: report tdls peers in debugfs
>   mwifiex: add bcn_rcv_cnt and bcn_miss_cnt in getlog debugfs
>   mwifiex: add rx histogram statistics support
>   mwifiex: move pm_wakeup_card_complete definition to usb.c
>   mwifiex: move debug_data dump function to common utililty file
>   mwifiex: save driver information to file when firmware dump
>   mwifiex: save sdio register values before firmware dump

All patches applied to wireless-drivers-next.git.

-- 
Kalle Valo
