Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33623 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaJJOBv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2014 10:01:51 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: use bss_info as txpower source
References: <1412940780-25360-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 10 Oct 2014 17:01:32 +0300
In-Reply-To: <1412940780-25360-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 10 Oct 2014 13:33:00 +0200")
Message-ID: <87ppe0aurn.fsf@kamboji.qca.qualcomm.com> (sfid-20141010_160154_414302_C8113D1C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This simply changes the source for txpower setup.
> It does not make ath10k use different txpower
> values for different vifs.
>
> This will make it easier to implement chanctx in
> ath10k in the future.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

In ath-next-test there was a conflict in ath10k_bss_info_changed().
Please check my resolution:

https://github.com/kvalo/ath/commit/86eea6fda33ce16a40f98d41c19ea4b0e157f5ba

-- 
Kalle Valo
