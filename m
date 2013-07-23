Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47284 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab3GWICe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jul 2013 04:02:34 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v4] ath10k: create debugfs interface to trigger fw crash
References: <878v1122id.fsf@kamboji.qca.qualcomm.com>
	<1374494931-18913-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 23 Jul 2013 11:02:25 +0300
In-Reply-To: <1374494931-18913-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 22 Jul 2013 14:08:51 +0200")
Message-ID: <87vc41wvou.fsf@kamboji.qca.qualcomm.com> (sfid-20130723_100239_658682_DF6312AA)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This can be useful for testing. To perform a
> forced firmware crash write 'crash' to
> 'simulate_fw_crash' debugfs file. E.g.
>
>   echo crash > /sys/kernel/debug/ieee80211/phy1/ath10k/simulate_fw_crash
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
> v3: return an appropriate errno instead of using ath10k_warn()

Thanks, applied.

-- 
Kalle Valo
