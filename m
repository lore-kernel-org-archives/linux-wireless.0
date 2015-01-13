Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:14416 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbbAMORv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 09:17:51 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Remove unused variable
References: <1420432822-10819-1-git-send-email-sujith@msujith.org>
Date: Tue, 13 Jan 2015 16:17:40 +0200
In-Reply-To: <1420432822-10819-1-git-send-email-sujith@msujith.org> (Sujith
	Manoharan's message of "Mon, 5 Jan 2015 10:10:22 +0530")
Message-ID: <87lhl669yz.fsf@kamboji.qca.qualcomm.com> (sfid-20150113_151754_782316_AAFB17F0)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> htt->max_throughput_mbps is not used anywhere.
>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Thanks, applied to ath.git. I just renamed the title to:

c3ebfede463c ath10k: Remove unused htt->max_throughput_mbps

-- 
Kalle Valo
