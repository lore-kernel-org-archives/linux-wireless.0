Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:6164 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaCXKIk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 06:08:40 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath10k: fix rssi and rate reporting
References: <1395394437-4048-1-git-send-email-janusz.dziedzic@tieto.com>
	<1395394437-4048-2-git-send-email-janusz.dziedzic@tieto.com>
Date: Mon, 24 Mar 2014 12:08:21 +0200
In-Reply-To: <1395394437-4048-2-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Fri, 21 Mar 2014 10:33:57 +0100")
Message-ID: <87eh1r7vu2.fsf@kamboji.qca.qualcomm.com> (sfid-20140324_110843_952364_E4FFCB51)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> RSSI and RATE fields are valid only when START_VALID
> bit is set. So, in current implementation we have to
> remember/caclulate them when START_VALID and report the same
> when only END_VALID is set. In other case during high
> RX traffic we will report invalid RSSI (-95) and RATE (6Mbps)
> when only END_VALID bit set.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

It's not clear for me what (user visible) bug you are fixing, please
describe that in the commit log.

-- 
Kalle Valo
