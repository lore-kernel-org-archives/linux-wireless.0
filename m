Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33777 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaBOG6E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Feb 2014 01:58:04 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath10k: implement sta_rc_update()
References: <1392042915-11648-1-git-send-email-michal.kazior@tieto.com>
	<1392385788-3983-1-git-send-email-michal.kazior@tieto.com>
Date: Sat, 15 Feb 2014 08:57:58 +0200
In-Reply-To: <1392385788-3983-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 14 Feb 2014 14:49:48 +0100")
Message-ID: <87ppmo50cp.fsf@kamboji.qca.qualcomm.com> (sfid-20140215_075832_542523_6C11AEDE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This allows dynamic changes of bandwidth/nss/smps,
> e.g. via ht/vht operation mode change
> notification.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
