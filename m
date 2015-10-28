Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45078 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbbJ1UDR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 16:03:17 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org, ath6kl@lists.infradead.org
Subject: Re: [PATCH 1/3] ath6k:  report antenna configuration.
References: <1445464401-13826-1-git-send-email-greearb@candelatech.com>
Date: Wed, 28 Oct 2015 22:03:09 +0200
In-Reply-To: <1445464401-13826-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Wed, 21 Oct 2015 14:53:19
	-0700")
Message-ID: <87r3kesqv6.fsf@kamboji.qca.qualcomm.com> (sfid-20151028_210340_588260_B6CD0A7A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> This lets 'iw phy phy0 info' report antennas for
> the radio device:
>
> ...
> 	Available Antennas: TX 0x2 RX 0x2
> 	Configured Antennas: TX 0x2 RX 0x2
> ...
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

The name of driver is ath6kl, note the letter 'l' :) I'll fix the commit
logs.

-- 
Kalle Valo
