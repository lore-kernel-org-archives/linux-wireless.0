Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:37791 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbaIBH3L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2014 03:29:11 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/2] ath10k: monitor fixes
References: <1409223497-19946-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 2 Sep 2014 10:29:05 +0300
In-Reply-To: <1409223497-19946-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 28 Aug 2014 12:58:15 +0200")
Message-ID: <87lhq2o4zi.fsf@kamboji.qca.qualcomm.com> (sfid-20140902_092923_859294_7CA74D26)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> This cleans up the monitor code a bit and
> introduces a workaround for a fw bug (leading to a
> fw crash) when station interface associates while
> a monitor vdev is running.
>
> People have been complaining about the fw crash
> for some time now. I guess we have no choice but
> to make a workaround in ath10k. The most common
> usecase that will benefit from this fix is
> probably 4addr sta briding.
>
>
> Michal Kazior (2):
>   ath10k: fix monitor start/stop sequences
>   ath10k: stop monitor vdev for sta assoc

Thanks, both patches applied.

-- 
Kalle Valo
