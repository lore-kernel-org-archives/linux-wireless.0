Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61590 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab3LBRBq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 12:01:46 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	"Michal Kazior" <michal.kazior@tieto.com>
Subject: Re: [PATCH v2] ath10k: fix multi BSSID with WPA on FW 10.1
References: <1385971596-3575-1-git-send-email-bartosz.markowski@tieto.com>
Date: Mon, 2 Dec 2013 19:01:39 +0200
In-Reply-To: <1385971596-3575-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Mon, 2 Dec 2013 09:06:36 +0100")
Message-ID: <87haarb30s.fsf@kamboji.qca.qualcomm.com> (sfid-20131202_180208_756465_42D276B8)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> From: Michal Kazior <michal.kazior@tieto.com>
>
> FW 10.1 seems to require the default key index to
> be updated to point to group key after it is
> installed. Otherwise Txed frames are corrupted.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
