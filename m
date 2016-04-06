Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60076 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbcDFS0q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 14:26:46 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Marty Faltesek <mfaltesek@google.com>
Cc: akarwar@marvell.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mwifiex: bridged packets cause wmm_tx_pending counter to go negative
References: <1457997683-14553-1-git-send-email-mfaltesek@google.com>
Date: Wed, 06 Apr 2016 21:26:41 +0300
In-Reply-To: <1457997683-14553-1-git-send-email-mfaltesek@google.com> (Marty
	Faltesek's message of "Mon, 14 Mar 2016 19:21:23 -0400")
Message-ID: <87a8l68ufy.fsf@kamboji.qca.qualcomm.com> (sfid-20160406_202649_063328_9FC3CD2A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marty Faltesek <mfaltesek@google.com> writes:

> When a packet is queued from the bridge, wmm_tx_pending is not
> incremented, but when the packet is dequeued the counter is decremented.

Signed-off-by line is missing, please resend.

-- 
Kalle Valo
