Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:20899 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaBNLZP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Feb 2014 06:25:15 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath10k: fix alignment in ath10k_dbg()
References: <20140213095652.13999.63855.stgit@potku.adurom.net>
Date: Fri, 14 Feb 2014 13:25:03 +0200
In-Reply-To: <20140213095652.13999.63855.stgit@potku.adurom.net> (Kalle Valo's
	message of "Thu, 13 Feb 2014 11:56:52 +0200")
Message-ID: <87bnya5434.fsf@kamboji.qca.qualcomm.com> (sfid-20140214_122528_848437_1A3ED893)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> checkpatch warning:
>
> drivers/net/wireless/ath/ath10k/debug.h:95: CHECK: Alignment should match open parenthesis
>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patches 1-3 applied.

-- 
Kalle Valo
