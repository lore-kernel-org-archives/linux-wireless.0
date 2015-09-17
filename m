Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8765 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbbIQLEW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 07:04:22 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: split switch_vif_chanctx guts
References: <1441269892-438-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 17 Sep 2015 14:04:11 +0300
In-Reply-To: <1441269892-438-1-git-send-email-michal.kazior@tieto.com> (Michal
	Kazior's message of "Thu, 3 Sep 2015 10:44:51 +0200")
Message-ID: <874mitux1w.fsf@kamboji.qca.qualcomm.com> (sfid-20150917_130425_281154_A3F7EEE1)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This is necessary to make vdev restarting logic
> reusable later.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, both patches applied.

-- 
Kalle Valo
