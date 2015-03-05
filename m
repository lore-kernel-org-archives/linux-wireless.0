Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19914 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbbCEOOh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2015 09:14:37 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Enable encrytion of ADDBA request in PMF configuration
References: <1425118689-32553-1-git-send-email-sjegadee@qti.qualcomm.com>
Date: Thu, 5 Mar 2015 16:14:26 +0200
In-Reply-To: <1425118689-32553-1-git-send-email-sjegadee@qti.qualcomm.com>
	(SenthilKumar Jegadeesan's message of "Sat, 28 Feb 2015 15:48:09
	+0530")
Message-ID: <87bnk74jlp.fsf@kamboji.qca.qualcomm.com> (sfid-20150305_151449_234569_9711B82D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com> writes:

> In HT mode, firmware is not encrypting ADDBA request as PMF
> configuration is not set in peer flags during association.
>
> Set peer flags for MFP enabled station in ath10k driver.
>
> Implemented abstraction layer for peer flags.
>
> This change depends on mac80211 patch "[PATCH] mac80211: send
> station PMF configuration to driver".
>
> Signed-off-by: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>

Typo in the title "encrytion".

-- 
Kalle Valo
