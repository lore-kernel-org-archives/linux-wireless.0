Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13341 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaJMHjB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2014 03:39:01 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/5] ath10k: split reset logic from power up
References: <1412842950-14098-1-git-send-email-michal.kazior@tieto.com>
	<1412842950-14098-5-git-send-email-michal.kazior@tieto.com>
Date: Mon, 13 Oct 2014 10:38:54 +0300
In-Reply-To: <1412842950-14098-5-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 9 Oct 2014 10:22:29 +0200")
Message-ID: <87k344a06p.fsf@kamboji.qca.qualcomm.com> (sfid-20141013_093906_935193_C12FCE79)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The power up procedure was overly complex due to
> warm/cold reset workarounds and issues.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> +	ret = ath10k_pci_wait_for_target_init(ar);
> +	if (ret) {
> +		ath10k_warn(ar, "failed to wait for target after cold reset: %d\n",
> +				ret);

Checkpatch warns:

ath10k/pci.c:1849: CHECK: Alignment should match open parenthesis

-- 
Kalle Valo
