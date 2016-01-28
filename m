Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42308 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966558AbcA1I0p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 03:26:45 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Maya Erez <qca_merez@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH 0/5] 11AD fixes
References: <1453027150-18224-1-git-send-email-qca_merez@qca.qualcomm.com>
Date: Thu, 28 Jan 2016 10:26:38 +0200
In-Reply-To: <1453027150-18224-1-git-send-email-qca_merez@qca.qualcomm.com>
	(Maya Erez's message of "Sun, 17 Jan 2016 12:39:05 +0200")
Message-ID: <87bn86m7nl.fsf@kamboji.qca.qualcomm.com> (sfid-20160128_092653_340715_787944F4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> writes:

> The below patches include several fixes to wil6210 driver:
> - Fixes in IEs handling
> - Fixes in TX vring validation before access
> - Fix in connect flow to allow concurrent multiple connect events
>
> Lior David (2):
>   wil6210: fix privacy flag calculation in change_beacon
>   wil6210: use extra IEs from probe response
>
> Maya Erez (3):
>   wil6210: handle tx completions only if vring tx data is enabled
>   wil6210: find TX vring only if vring_tx_data is enabled
>   wil6210: handle multiple connect/disconnect events

All applied to ath.git, thanks.

Please remember to use "wil6210: " prefix also in the cover letter,
makes it easier to filter and find it.

-- 
Kalle Valo
