Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:1397 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab3HLOV5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 10:21:57 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: Remove qca98xx hw1.0 support
References: <1375881466-30090-1-git-send-email-bartosz.markowski@tieto.com>
Date: Mon, 12 Aug 2013 17:21:51 +0300
In-Reply-To: <1375881466-30090-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Wed, 7 Aug 2013 15:17:45 +0200")
Message-ID: <87pptjt2f4.fsf@kamboji.qca.qualcomm.com> (sfid-20130812_162200_197872_3E2E56C1)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> Since the firmware support is no longer available for hw1.0,
> drop all code (especially workarounds) for those units.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

Thanks, both applied.

-- 
Kalle Valo
