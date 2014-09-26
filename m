Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16531 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829AbaIZKhV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2014 06:37:21 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 0/3] ath10k: export calibration data to user space
References: <20140924111416.6539.95299.stgit@potku.adurom.net>
Date: Fri, 26 Sep 2014 13:36:34 +0300
In-Reply-To: <20140924111416.6539.95299.stgit@potku.adurom.net> (Kalle Valo's
	message of "Wed, 24 Sep 2014 14:16:39 +0300")
Message-ID: <8761ga653h.fsf@kamboji.qca.qualcomm.com> (sfid-20140926_123730_913625_681D5EA8)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Here's a small patchset exporting firmware calibration data to user space. This
> makes it easier to debug various calibration data related problems.
>
> Please comment.
>
> v3:
>
> * patch 1: fix comment style (Michal)
>
> * patch 3: use ath10k_debug_ prefix (Michal)
>
> v2:
>
> * never unmask the diagnostic window copy engine pipe in
>   ath10k_ce_enable_interrupts()
>
> * add locking for diag_read_mem()/diag_write_mem()
>
> ---
>
> Kalle Valo (3):
>       ath10k: don't enable interrupts for the diagnostic window
>       ath10k: add diag_read() to hif ops
>       ath10k: add cal_data debugfs file

All three patches applied.

-- 
Kalle Valo
