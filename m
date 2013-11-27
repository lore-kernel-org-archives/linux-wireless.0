Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:37693 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab3K0Orz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Nov 2013 09:47:55 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 8/8] ath10k: allow explicit MSI/MSI-X disabling
References: <1385125518-13461-1-git-send-email-michal.kazior@tieto.com>
	<1385384787-12470-1-git-send-email-michal.kazior@tieto.com>
	<1385384787-12470-9-git-send-email-michal.kazior@tieto.com>
Date: Wed, 27 Nov 2013 16:47:49 +0200
In-Reply-To: <1385384787-12470-9-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 25 Nov 2013 14:06:27 +0100")
Message-ID: <87y549gaui.fsf@kamboji.qca.qualcomm.com> (sfid-20131127_154759_354741_5567E31E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This can be useful for testing and debugging.
>
> This introduces new ath10k_pci module parameter
> `irq_mode`. By default it is 0, meaning automatic
> irq mode (MSI-X as long as both target HW and host
> platform supports it). The parameter works on a
> best effort basis.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> +MODULE_PARM_DESC(irq_mode, "0: ayto, 1: legacy, 2: msi (default: 0)");

I fixed this typo ("ayto").

-- 
Kalle Valo
