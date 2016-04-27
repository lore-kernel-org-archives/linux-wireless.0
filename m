Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58127 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbcD0Nvo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2016 09:51:44 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2] mwifiex: transmit packet stats incorrect.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1461126121-12266-1-git-send-email-mfaltesek@google.com>
To: Marty Faltesek <mfaltesek@google.com>
Cc: linux-wireless@vger.kernel.org, akarwar@marvell.com
Message-Id: <20160427135138.871AA612F5@smtp.codeaurora.org> (sfid-20160427_155158_370781_1E2206DF)
Date: Wed, 27 Apr 2016 13:51:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> tx_packets counter is incremented for aggregated packets, when it had
> already been incremented for the aggregated packet's constituent
> parts. Removing the extra count.
> 
> Signed-off-by: Marty Faltesek <mfaltesek@google.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
