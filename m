Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:5160 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbbC3NP1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 09:15:27 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: disable burst mode
References: <1427271291-31683-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Mon, 30 Mar 2015 16:15:18 +0300
In-Reply-To: <1427271291-31683-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Wed, 25 Mar 2015 09:14:51 +0100")
Message-ID: <87iodi4oex.fsf@kamboji.qca.qualcomm.com> (sfid-20150330_151531_890382_FBB26CB3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Firmwares that indicate BURST_SERVICE as enabled
> could overwrite some wmm parameters (eg. txop).
> This could lead IOT and balancing issues.
> Hence disable this by default.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

There was a trivial conflict, please check my resolution in the pending
branch.

-- 
Kalle Valo
