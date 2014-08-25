Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39184 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937AbaHYIZi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2014 04:25:38 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v8 0/4] ath10k: firmware crash dump
References: <20140821124705.27159.67898.stgit@potku.adurom.net>
Date: Mon, 25 Aug 2014 11:25:33 +0300
In-Reply-To: <20140821124705.27159.67898.stgit@potku.adurom.net> (Kalle Valo's
	message of "Thu, 21 Aug 2014 15:48:50 +0300")
Message-ID: <877g1x6kn6.fsf@kamboji.qca.qualcomm.com> (sfid-20140825_102556_742262_A459623B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> And yet another version of firmware crash dumps. Now I dropped all dumps except
> firmware registers and tested all the features myself.

[...]

> Ben Greear (1):
>       ath10k: provide firmware crash info via debugfs
>
> Kalle Valo (3):
>       ath10k: add ath10k_pci_diag_* helpers
>       ath10k: rename ath10k_pci_hif_dump_area() to ath10k_pci_fw_crashed_dump()
>       ath10k: print more driver info when firmware crashes

Finally applied :)

I also applied the small diff to patch 2 to remove the unneeded use of
mutex in ath10k_fw_crash_dump_open().

-- 
Kalle Valo
