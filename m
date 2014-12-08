Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7386 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbaLHPlm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2014 10:41:42 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v4 0/8] ath10k: add support for new wmi-tlv backend
References: <20141203080803.31187.85059.stgit@potku.adurom.net>
Date: Mon, 8 Dec 2014 17:41:31 +0200
In-Reply-To: <20141203080803.31187.85059.stgit@potku.adurom.net> (Kalle Valo's
	message of "Wed, 3 Dec 2014 10:09:16 +0200")
Message-ID: <87wq62ywr8.fsf@kamboji.qca.qualcomm.com> (sfid-20141208_164153_786463_3FD4B77C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> here's v4 of Michal's patches to add WMI TLV interface support to
> ath10k.

[...]

> Kalle Valo (4):
>       ath10k: clean up error handling in ath10k_core_probe_fw()
>       ath10k: create ath10k_core_init_features()
>       ath10k: add ATH10K_FW_IE_WMI_OP_VERSION
>       ath10k: set max_num_pending_tx in ath10k_core_init_firmware_features()
>
> Michal Kazior (4):
>       ath10k: implement intermediate event args
>       ath10k: introduce wmi ops
>       ath10k: make some wmi functions public
>       ath10k: implement wmi-tlv backend

All four applied. Thanks Michal.

-- 
Kalle Valo
