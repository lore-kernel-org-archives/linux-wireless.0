Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59789 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbcDFSXc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 14:23:32 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Marty Faltesek <mfaltesek@google.com>
Cc: akarwar@marvell.com, linux-wireless@vger.kernel.org,
	dgentry@google.com, apenwarr@google.com
Subject: Re: [PATCH] mwifiex: transmit packet stats incorrect.
References: <1458609235-14686-1-git-send-email-mfaltesek@google.com>
Date: Wed, 06 Apr 2016 21:23:15 +0300
In-Reply-To: <1458609235-14686-1-git-send-email-mfaltesek@google.com> (Marty
	Faltesek's message of "Mon, 21 Mar 2016 21:13:55 -0400")
Message-ID: <87inzu8ulo.fsf@kamboji.qca.qualcomm.com> (sfid-20160406_202336_779401_D8798374)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marty Faltesek <mfaltesek@google.com> writes:

> tx_packets counter is incremented for aggregated packets, when it had
> already been incremented for the aggregated packet's constituent
> parts. Removing the extra count.

Because Signed-off-by line is missing I can't take this. Please resend.

-- 
Kalle Valo
