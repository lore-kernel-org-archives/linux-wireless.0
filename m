Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:58419 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbbDARU4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2015 13:20:56 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix survey reporting
References: <1427200691-7109-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 1 Apr 2015 20:20:47 +0300
In-Reply-To: <1427200691-7109-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 24 Mar 2015 12:38:11 +0000")
Message-ID: <87oan7ydcg.fsf@kamboji.qca.qualcomm.com> (sfid-20150401_192059_679470_D45F95C6)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Number of channels is stored in a separate macro
> in a header file and channel list is constructed
> independently. The macro is used to define survey
> array.
>
> This fixes a recent regression introduced after
> adding support for 144 channel. The regression
> would lead to a warning and incomplete survey data
> on channel 165:
>
>   chan info: invalid frequency 5825 (idx 38 out of bounds)
>
> Also make sure to enforce the sizes and avoid this
> kind of problem in the future.
>
> Fixes: 4a7898fed5f3 ("ath10k: enable channel 144 on 5GHz band")
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
