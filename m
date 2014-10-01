Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:2594 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaJAIWy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2014 04:22:54 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2 01/10] ath10k: use 64-bit vdev map.
References: <1411507045-18973-1-git-send-email-greearb@candelatech.com>
Date: Wed, 1 Oct 2014 11:22:23 +0300
In-Reply-To: <1411507045-18973-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Tue, 23 Sep 2014 14:17:16
	-0700")
Message-ID: <87vbo4td1c.fsf@kamboji.qca.qualcomm.com> (sfid-20141001_102258_374033_02F08BC4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> This can allow more than 32 stations to be supported
> without over-running the bitmap.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

Thanks, I have applied this patch.

-- 
Kalle Valo
