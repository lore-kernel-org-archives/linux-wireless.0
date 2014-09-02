Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5446 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaIBHSX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2014 03:18:23 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix num_legacy_stations tracking
References: <1409212779-5212-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 2 Sep 2014 10:17:45 +0300
In-Reply-To: <1409212779-5212-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 28 Aug 2014 09:59:39 +0200")
Message-ID: <87wq9mo5ie.fsf@kamboji.qca.qualcomm.com> (sfid-20140902_091825_777857_BB50D7FB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> If a station was reassociated, i.e. due to change
> of supported rates update via sta_rc_update() the
> num_legacy_stations would be (incorrectly) bumped
> up leading to unbalanced usage of the var. This in
> turn could lock rtscts protection up as enabled.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
