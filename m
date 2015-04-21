Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:29139 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbbDURhT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2015 13:37:19 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ath10k: share board file loading code across FW APIs
References: <1429262357-25139-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 21 Apr 2015 20:37:10 +0300
In-Reply-To: <1429262357-25139-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 17 Apr 2015 09:19:16 +0000")
Message-ID: <87fv7tz8l5.fsf@kamboji.qca.qualcomm.com> (sfid-20150421_193723_562657_7E6F472C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> There's no need to implement the same thing twice.
> Reduce code duplication.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, both patches applied.

-- 
Kalle Valo
