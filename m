Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2980 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab3ILQMQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Sep 2013 12:12:16 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/8] ath10k: boot, bmi and mac debug message cleanup
References: <20130908145435.3136.49168.stgit@localhost6.localdomain6>
Date: Thu, 12 Sep 2013 19:12:13 +0300
In-Reply-To: <20130908145435.3136.49168.stgit@localhost6.localdomain6> (Kalle
	Valo's message of "Sun, 08 Sep 2013 17:55:25 +0300")
Message-ID: <87d2oef28y.fsf@qca.qualcomm.com> (sfid-20130912_181220_826718_BADCBACB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Simple message log cleanup. Please review.
>
> ---
>
> Kalle Valo (8):
>       ath10k: add BMI log level
>       ath10k: rename ATH10K_DBG_CORE to BOOT
>       ath10k: cleanup debug messages in core.c
>       ath10k: add boot debug messages to pci.c and ce.c
>       ath10k: add boot debug messages to htc.c
>       ath10k: add boot messages to htt.c
>       ath10k: clean mac.c debug messages
>       ath10k: print phymode as a string

Applied.

Kalle
