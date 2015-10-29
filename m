Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18882 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbbJ2LCA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 07:02:00 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/4] ath10k: remove supported chain mask
References: <1445948474-16738-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Thu, 29 Oct 2015 13:01:40 +0200
In-Reply-To: <1445948474-16738-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Tue, 27 Oct 2015 17:51:11 +0530")
Message-ID: <87fv0uq6p7.fsf@kamboji.qca.qualcomm.com> (sfid-20151029_120203_833736_B0E480E5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Removing supported chainmask fields as it can be always derived
> from num_rf_chains.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

All four patches applied, thanks.

-- 
Kalle Valo
