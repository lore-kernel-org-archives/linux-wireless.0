Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:35354 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756612AbbCGH7K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2015 02:59:10 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: refactor p2p noa code
References: <1424953398-18809-1-git-send-email-michal.kazior@tieto.com>
Date: Sat, 7 Mar 2015 09:59:00 +0200
In-Reply-To: <1424953398-18809-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 26 Feb 2015 13:23:17 +0100")
Message-ID: <87wq2tz1a3.fsf@kamboji.qca.qualcomm.com> (sfid-20150307_085913_591418_7F80BA16)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Some files are getting bloated and it makes sense
> to split some of the code into separate files. Do
> so with the P2P NoA code and prepare it for reuse.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, both patches applied.

-- 
Kalle Valo
