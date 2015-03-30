Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:27197 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbbC3MXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 08:23:53 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix aid setup in station mode
References: <1427104648-5681-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 30 Mar 2015 15:23:44 +0300
In-Reply-To: <1427104648-5681-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 23 Mar 2015 09:57:28 +0000")
Message-ID: <87vbhi4qsv.fsf@kamboji.qca.qualcomm.com> (sfid-20150330_142356_459758_1D8A5E51)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> While debugging something else I noticed AID was
> set to 0. This could lead to powersave issues in
> station mode. Maybe this isn't really necessary
> but set it properly just to be sure.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
