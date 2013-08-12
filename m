Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:27374 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab3HLOa2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 10:30:28 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/4] ath10k: cleanups
References: <1375949650-9699-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 12 Aug 2013 17:30:22 +0300
In-Reply-To: <1375949650-9699-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 8 Aug 2013 10:14:06 +0200")
Message-ID: <87haevt20x.fsf@kamboji.qca.qualcomm.com> (sfid-20130812_163031_503240_B8652E2E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This patchset contains a few non-functional clean
> ups.
>
> Michal Kazior (4):
>   ath10k: clean up monitor start code
>   ath10k: use sizeof(*var) in kmalloc
>   ath10k: clean up PCI completion states
>   ath10k: print errcode when CE ring setup fails

Thanks, all four applied.

-- 
Kalle Valo
