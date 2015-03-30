Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44557 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbbC3L6L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 07:58:11 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix HTT op backwards compatibility for QCA6174
References: <20150330111428.22198.36611.stgit@potku.adurom.net>
Date: Mon, 30 Mar 2015 14:57:59 +0300
In-Reply-To: <20150330111428.22198.36611.stgit@potku.adurom.net> (Kalle Valo's
	message of "Mon, 30 Mar 2015 14:14:28 +0300")
Message-ID: <87d23q66k8.fsf@kamboji.qca.qualcomm.com> (sfid-20150330_135814_679233_B9BA3EF1)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Commit 8348db298496 ("ath10k: add ATH10K_FW_IE_HTT_OP_VERSION") broke QCA6174
> receive side as the HTT ids from ATH10K_FW_HTT_OP_VERSION_MAIN don't have
> HTT_TLV_T2H_MSG_TYPE_RX_IN_ORD_PADDR_IND set. Fix this by adding a backwards
> compatibility code which sets HTT op version if it's not set by the firmare
> image.
>
> Fixes: 8348db298496 ("ath10k: add ATH10K_FW_IE_HTT_OP_VERSION")
> Reported-by: Michal Kazior <michal.kazior@tieto.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Applied.

-- 
Kalle Valo
