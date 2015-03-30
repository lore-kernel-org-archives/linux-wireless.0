Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38894 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbbC3GYA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 02:24:00 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] ath10k: add ATH10K_FW_IE_HTT_OP_VERSION
References: <20150325110835.30133.509.stgit@x230>
Date: Mon, 30 Mar 2015 09:23:51 +0300
In-Reply-To: <20150325110835.30133.509.stgit@x230> (Kalle Valo's message of
	"Wed, 25 Mar 2015 13:12:13 +0200")
Message-ID: <87619j6m14.fsf@kamboji.qca.qualcomm.com> (sfid-20150330_082403_271080_DA8C6EE4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> My proposal how to solve the differences between HTT interfaces by adding
> ATH10K_FW_IE_HTT_OP_VERSION. Based on Rajkumar's "ath10k: fix htt t2h message
> conflicts among firmware revisions", I just added the new IE and bumped up the
> FW API.
>
> For now only compile tested, I will run proper tests later.
>
> ---
>
> Kalle Valo (1):
>       ath10k: bump up FW API to 5
>
> Rajkumar Manoharan (1):
>       ath10k: add ATH10K_FW_IE_HTT_OP_VERSION

Applied.

-- 
Kalle Valo
