Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:13056 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3CRLeQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 07:34:16 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath6kl-devel@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: print firmware capabilities
References: <20130306065606.23473.77631.stgit@localhost6.localdomain6>
Date: Mon, 18 Mar 2013 13:34:10 +0200
In-Reply-To: <20130306065606.23473.77631.stgit@localhost6.localdomain6> (Kalle
	Valo's message of "Wed, 6 Mar 2013 08:56:06 +0200")
Message-ID: <87txo97xhp.fsf@kamboji.qca.qualcomm.com> (sfid-20130318_123419_561580_D5AC4E0D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Printin the  firmware capabilities during the first firmware boot makes it easier to find out what
> features firmware supports.
>
> Obligatory screenshot:
>
> [21025.678481] ath6kl: ar6003 hw 2.1.1 sdio fw 3.2.0.144 api 3
> [21025.678667] ath6kl: firmware supports: sched-scan,sta-p2pdev-duplex,rsn-cap-override
>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Applied with cosmetic fixes to the commit log.

-- 
Kalle Valo
