Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:22772 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906AbaGVPyu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 11:54:50 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: simplify tx helpers
References: <1405601122-29726-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 22 Jul 2014 18:54:44 +0300
In-Reply-To: <1405601122-29726-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 17 Jul 2014 14:45:21 +0200")
Message-ID: <87iompv16j.fsf@kamboji.qca.qualcomm.com> (sfid-20140722_175453_264562_9587702D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> It always bugged me how tid is computed and stored
> in a temporary var before written to the control
> buffer. It was confusing and it made it difficult
> to work with tx helpers.
>
> While at it rename the qos workaround function as
> it was misleading - it's not a workaround but
> preparation for nwifi tx mode.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, both patches applied.

-- 
Kalle Valo
