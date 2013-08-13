Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:37208 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757950Ab3HMOrL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 10:47:11 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: check allocation errors in CE
References: <1376030353-32421-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Tue, 13 Aug 2013 17:47:05 +0300
In-Reply-To: <1376030353-32421-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Fri, 9 Aug 2013 08:39:13 +0200")
Message-ID: <87ppth8x7a.fsf@kamboji.qca.qualcomm.com> (sfid-20130813_164722_311306_28D7F737)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Handle pci_alloc_consistent(), kmalloc()
> errors in copy engine module.
> Found during code review.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Thanks, applied.

-- 
Kalle Valo
