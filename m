Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:1804 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab3IIWfA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 18:35:00 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: define ath10k_debug_start/_stop as static inline
References: <1378741845-30080-1-git-send-email-bartosz.markowski@tieto.com>
Date: Tue, 10 Sep 2013 01:34:39 +0300
In-Reply-To: <1378741845-30080-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Mon, 9 Sep 2013 17:50:45 +0200")
Message-ID: <87mwnl7hfk.fsf@kamboji.qca.qualcomm.com> (sfid-20130910_003507_259335_31CE06DB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> Otherwise if CONFIG_ATH10K_DEBUGFS won't be set we will
> end up with multiple definitions and compilation failure
> in each place the header is included.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

Doh, I broke this. Sorry about that. Path applied, thanks for fixing
this.

-- 
Kalle Valo
