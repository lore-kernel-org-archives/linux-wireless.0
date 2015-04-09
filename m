Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4655 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294AbbDIMF2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2015 08:05:28 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: fix arvif->wep_keys clearing
References: <1427444516-974-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 9 Apr 2015 15:05:22 +0300
In-Reply-To: <1427444516-974-1-git-send-email-michal.kazior@tieto.com> (Michal
	Kazior's message of "Fri, 27 Mar 2015 08:21:55 +0000")
Message-ID: <87zj6heccd.fsf@kamboji.qca.qualcomm.com> (sfid-20150409_140532_583365_02C1F626)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The variable should be cleared regardless of
> whether there's a peer associated with the key or
> not.
>
> This fixes case when user first associates with 2
> WEP keys and then disconnects and connects with 1
> WEP key. This resulted in WEP key count being 2 in
> the driver leading to default keyidx fixup
> failure.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, both patches applied.

-- 
Kalle Valo
