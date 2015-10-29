Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44989 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbbJ2Lfp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 07:35:45 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org, ath6kl@lists.infradead.org
Subject: Re: [PATCH-v2 1/2] ath6k:  break stats gathering code into separate method.
References: <1445530059-6276-1-git-send-email-greearb@candelatech.com>
Date: Thu, 29 Oct 2015 13:35:37 +0200
In-Reply-To: <1445530059-6276-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Thu, 22 Oct 2015 09:07:38
	-0700")
Message-ID: <8737wtrjp1.fsf@kamboji.qca.qualcomm.com> (sfid-20151029_123547_924531_8CBDC065)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> This will allow us to call it from elsewhere when implementing
> ethtool stats.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

Both patches applied, thanks.

-- 
Kalle Valo
