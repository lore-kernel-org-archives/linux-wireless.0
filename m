Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:18748 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647AbaGURwZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 13:52:25 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: workaround boot issues with KVM/PCI-passthrough
References: <1405515699-32452-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 21 Jul 2014 20:52:20 +0300
In-Reply-To: <1405515699-32452-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 16 Jul 2014 15:01:39 +0200")
Message-ID: <878unmy4yz.fsf@kamboji.qca.qualcomm.com> (sfid-20140721_195228_941041_C235AFD6)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Apparently iomap writes that unmask CE irqs aren't
> propagated properly sometimes. Before failing try
> to poll for the control response message as it may
> have been delivered without an interrupt.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
