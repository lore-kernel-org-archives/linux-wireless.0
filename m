Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:47181 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603AbbI0M6I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2015 08:58:08 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix MSI-X registering for qca99x0
References: <1442470653-25162-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Sun, 27 Sep 2015 15:57:56 +0300
In-Reply-To: <1442470653-25162-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Thu, 17 Sep 2015 08:17:33 +0200")
Message-ID: <877fncc94b.fsf@kamboji.qca.qualcomm.com> (sfid-20150927_145812_818488_8D8D7DCA)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> In case of qca99x0 and MSI-X supported/enabled we
> failed during interrupts registering with message:
>
> ath10k_pci 0000:04:00.0: failed to request MSI-X ce irq 50: -22
>
> Issue/fix was reproduced/tested using Dell Latitude E6430 laptop.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Thanks, applied.

-- 
Kalle Valo
