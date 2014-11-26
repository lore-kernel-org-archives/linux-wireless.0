Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:25893 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbaKZGpA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 01:45:00 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] ath10k: add missing goto
References: <1416834909-7130-1-git-send-email-michal.kazior@tieto.com>
	<1416924965-28216-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 26 Nov 2014 08:44:55 +0200
In-Reply-To: <1416924965-28216-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 25 Nov 2014 15:16:03 +0100")
Message-ID: <87d28axxy0.fsf@kamboji.qca.qualcomm.com> (sfid-20141126_074505_423738_3085D7BF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This prevents warning spamming if peer creation
> fails during sta_state in some cases.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, all three patches applied.

-- 
Kalle Valo
