Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49589 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758112AbcEFLwG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2016 07:52:06 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: meijjaa <jjmeijer88@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Fix regression in Android due to rework .get_station() callback
References: <1462280620-13000-1-git-send-email-jjmeijer88@gmail.com>
Date: Fri, 06 May 2016 14:51:59 +0300
In-Reply-To: <1462280620-13000-1-git-send-email-jjmeijer88@gmail.com>
	(meijjaa's message of "Tue, 3 May 2016 15:03:40 +0200")
Message-ID: <87poszs8tc.fsf@kamboji.qca.qualcomm.com> (sfid-20160506_135210_936064_07C3B298)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

meijjaa <jjmeijer88@gmail.com> writes:

> After f654d13 Android is not able to get station signal strength.
> To much was removed, this patch brings back the needed functionality.
>
> Signed-off-by: meijjaa <jjmeijer88@gmail.com>

This has multiple issues:

o Use your full name.

o Use prefix "brcmfmac: " in the title.

o I can't find commit f654d13, is the commit id really correct?

o Also check from SubmittingPatches how you should reference commit ids.

-- 
Kalle Valo
