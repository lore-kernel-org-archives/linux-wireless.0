Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:46735 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbaB0Qj4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 11:39:56 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: enable spectrum management support
References: <1393311554-8131-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Thu, 27 Feb 2014 18:39:50 +0200
In-Reply-To: <1393311554-8131-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Tue, 25 Feb 2014 07:59:14 +0100")
Message-ID: <87lhwwech5.fsf@kamboji.qca.qualcomm.com> (sfid-20140227_173959_166229_88370609)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Indicate spectrum management support in hardware
> flags, while we already handle power set
> (IEEE80211_CONF_CHANGE_POWER) in the ath10k driver.
> This enable 802.11h support for station mode.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Thanks, applied.

-- 
Kalle Valo
