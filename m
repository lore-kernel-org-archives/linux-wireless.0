Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57906 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbcD0NuH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2016 09:50:07 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2] mwifiex: bridged packets cause wmm_tx_pending counter to
 gonegative
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1461125975-12002-1-git-send-email-mfaltesek@google.com>
To: Marty Faltesek <mfaltesek@google.com>
Cc: linux-wireless@vger.kernel.org, akarwar@marvell.com
Message-Id: <20160427135005.EA38F612F0@smtp.codeaurora.org> (sfid-20160427_155014_815460_3189B1E3)
Date: Wed, 27 Apr 2016 13:50:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> When a packet is queued from the bridge, wmm_tx_pending is not
> incremented, but when the packet is dequeued the counter is decremented.
> 
> Signed-off-by: Marty Faltesek <mfaltesek@google.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
