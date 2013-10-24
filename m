Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58756 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab3JXFne (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Oct 2013 01:43:34 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/3] ath10k: tx power fixes
References: <1382526135-3215-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 24 Oct 2013 08:43:28 +0300
In-Reply-To: <1382526135-3215-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 23 Oct 2013 04:02:12 -0700")
Message-ID: <87iownjkan.fsf@kamboji.qca.qualcomm.com> (sfid-20131024_074337_380471_29054420)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> This patchset fixes power units used in ath10k and
> also make it respect (user) configurable tx power.
>
>
> Michal Kazior (3):
>   ath10k: setup min channel power to a reasonable value
>   ath10k: use proper tx power unit
>   ath10k: respect power_level values

Thanks, all patches applied.

-- 
Kalle Valo
