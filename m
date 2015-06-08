Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:63667 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbbFHNRh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 09:17:37 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: enable VHT for IBSS
References: <1433742144-19876-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Mon, 8 Jun 2015 16:17:31 +0300
In-Reply-To: <1433742144-19876-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Mon, 8 Jun 2015 07:42:24 +0200")
Message-ID: <871thmjq50.fsf@kamboji.qca.qualcomm.com> (sfid-20150608_151740_570295_792DF882)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Enable VHT support for IBSS.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

You should give background info here. For example, why did you enable
now and not earlier? How did you test it? What user space requirements
(wpasupplicant version etc) there are? What kind of throughput did you
see?

-- 
Kalle Valo
