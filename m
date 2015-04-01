Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:58628 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbbDARWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2015 13:22:47 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: don't call quiet mode if it's not implemented
References: <1427200817-7407-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 1 Apr 2015 20:22:29 +0300
In-Reply-To: <1427200817-7407-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 24 Mar 2015 12:40:17 +0000")
Message-ID: <87k2xvyd9m.fsf@kamboji.qca.qualcomm.com> (sfid-20150401_192252_137244_3543E885)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> qca6174 and wmi-tlv doesn't have quiet mode
> implemented. Don't even attempt to call it. This
> fixes a warning when bringing first interface up:
>
>   failed to set quiet mode period 100 duarion 0 enabled 0 ret -95
>
> Fixes: 8515b5c79a54 ("ath10k: configure thermal throttle while powering up")
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
