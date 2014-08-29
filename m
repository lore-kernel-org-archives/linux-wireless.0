Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:40506 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbaH2MTY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2014 08:19:24 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add device/driver strings to tracepoints
References: <1409231135-16233-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 29 Aug 2014 15:19:18 +0300
In-Reply-To: <1409231135-16233-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 28 Aug 2014 15:05:35 +0200")
Message-ID: <877g1rsd2x.fsf@kamboji.qca.qualcomm.com> (sfid-20140829_141928_686466_1B60C9C7)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This makes it easier to log and debug via tracing
> with more than 1 ath10k device on a system.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
> Not sure if pulling core.h in trace.h and using ar
> pointer is the best approach here. Alternative is
> to not pull core.h and pass ar->dev directly to
> trace functions. Thoughts?

I can't really say, I'm not that familiar with the tracing stuff. To
this approach looks good but let's see what others say (if anything).

-- 
Kalle Valo
