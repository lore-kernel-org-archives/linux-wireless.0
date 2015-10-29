Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44958 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbbJ2Le4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 07:34:56 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org, ath6kl@lists.infradead.org
Subject: Re: [PATCH 1/3] ath6k:  report antenna configuration.
References: <1445464401-13826-1-git-send-email-greearb@candelatech.com>
Date: Thu, 29 Oct 2015 13:34:49 +0200
In-Reply-To: <1445464401-13826-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Wed, 21 Oct 2015 14:53:19
	-0700")
Message-ID: <877fm5rjqe.fsf@kamboji.qca.qualcomm.com> (sfid-20151029_123459_091812_AC4060F0)
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

All three applied, thanks.

-- 
Kalle Valo
