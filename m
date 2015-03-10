Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49667 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbbCJILm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 04:11:42 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH] ath9k_htc: force FW v1.4.0
References: <1425929918-860-1-git-send-email-linux@rempel-privat.de>
Date: Tue, 10 Mar 2015 10:11:34 +0200
In-Reply-To: <1425929918-860-1-git-send-email-linux@rempel-privat.de> (Oleksij
	Rempel's message of "Mon, 9 Mar 2015 20:38:38 +0100")
Message-ID: <87385dz2yx.fsf@kamboji.qca.qualcomm.com> (sfid-20150310_091147_992732_C94221C8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oleksij Rempel <linux@rempel-privat.de> writes:

> Now we have offically FW v1.4. Force users to update it and prevent reporting of old bugs.
>
> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>

1.4 seems to be pretty new:

commit 216de39deef589d1a233abb2037d765aebbf4151
Author: Adrian Chadd <adrian@freebsd.org>
Date:   Wed Mar 4 10:06:34 2015 -0800

    Add v1.4.0 firmware for ath9k_htc.

I don't think it's good practise to make ath9k_htc break with older
firmware versions so quickly, especially if there's no technical reason.
The best would be to wait few months (maybe six?) before forcing the new
version, that way user space has time to catch up.

Maybe for now you could add a warning about using old firmware version?

-- 
Kalle Valo
