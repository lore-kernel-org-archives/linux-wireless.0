Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:15298 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964883Ab3GENY6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 09:24:58 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath9k-devel@lists.ath9k.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [PATCH v2] ath10k: fix 5ghz channel definitions
References: <1372060350-31460-3-git-send-email-michal.kazior@tieto.com>
	<1372229694-6769-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 5 Jul 2013 16:24:48 +0300
In-Reply-To: <1372229694-6769-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 26 Jun 2013 08:54:54 +0200")
Message-ID: <8738rtgmvz.fsf@kamboji.qca.qualcomm.com> (sfid-20130705_152505_578305_21B95A31)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Nonsense channel flags were being set.
>
> Although it doesn't seem this was visible to the
> user the patch makes sure that channel
> availability won't be crippled in the future if
> ath_common behaviour changes.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

John also applied this already.

-- 
Kalle Valo
