Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:65176 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbbFIKxg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 06:53:36 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Raja Mani <rmani@qti.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2] ath10k: remove unused variable 'id' in ath10k_pci_tx_pipe_cleanup()
References: <1433230455-11644-1-git-send-email-rmani@qti.qualcomm.com>
Date: Tue, 9 Jun 2015 13:53:31 +0300
In-Reply-To: <1433230455-11644-1-git-send-email-rmani@qti.qualcomm.com> (Raja
	Mani's message of "Tue, 2 Jun 2015 13:04:15 +0530")
Message-ID: <87k2vdf904.fsf@kamboji.qca.qualcomm.com> (sfid-20150609_125339_682446_EF98CC2E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Raja Mani <rmani@qti.qualcomm.com> writes:

> mete_data is extracted from ce descriptor and stored in variable 'id'.
> later, id is not used anywhere in the same function.
>
> Fixes: d84a512dca23 ("ath10k: remove transfer_id from
> ath10k_hif_cb::tx_completion")
>
> Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
