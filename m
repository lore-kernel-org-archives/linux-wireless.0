Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4917 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbaKZG0O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 01:26:14 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2 06/10] ath10k: use configured nss instead of max nss.
References: <1411507045-18973-1-git-send-email-greearb@candelatech.com>
	<1411507045-18973-6-git-send-email-greearb@candelatech.com>
Date: Wed, 26 Nov 2014 08:26:08 +0200
In-Reply-To: <1411507045-18973-6-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Tue, 23 Sep 2014 14:17:21
	-0700")
Message-ID: <877fyizddr.fsf@kamboji.qca.qualcomm.com> (sfid-20141126_072620_484593_B7CCA928)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> When re-associating a station, the nss was set back to
> maximum value even if user had configured small number
> of tx chains.  So, pay attention to user's config in
> this case as well.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

Thanks, applied.

-- 
Kalle Valo
