Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:4584 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbbDOMQh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2015 08:16:37 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Peter Oh <poh@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ath: define JP DFS patterns separated from FCC
References: <413e207292d5c52cd621912762e6d4a40a8dfc48.1427845453.git.poh@qca.qualcomm.com>
Date: Wed, 15 Apr 2015 15:16:27 +0300
In-Reply-To: <413e207292d5c52cd621912762e6d4a40a8dfc48.1427845453.git.poh@qca.qualcomm.com>
	(Peter Oh's message of "Tue, 31 Mar 2015 16:44:42 -0700")
Message-ID: <87k2xd7fj8.fsf@kamboji.qca.qualcomm.com> (sfid-20150415_141640_394106_80826B14)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@qca.qualcomm.com> writes:

> Separate Japan's DFS pattern from FCC to control PPB threshold.
>
> Currently all the radar detectors use the same threshold rate at
> 50%, but it's not able to achieve if data traffic rate is higher
> than 40% because WLAN baseband used by ath9k and ath10k often fails
> detecting radar pulses, so that SW cannot get enough radar reports
> to achieve the rate.
>
> Since Japan's W53 band requires 50% data traffic during its DFS
> test we need to apply different threshold rate than others on it.
> Hence define its own pattern to give flexibility to threshold rate.
>
> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>

Thanks, both patches applied.

-- 
Kalle Valo
