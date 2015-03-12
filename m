Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:41936 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbbCLMhG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 08:37:06 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix WPA crypto
References: <1425907457-15118-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 12 Mar 2015 14:36:57 +0200
In-Reply-To: <1425907457-15118-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 9 Mar 2015 14:24:17 +0100")
Message-ID: <87twxqv1cm.fsf@kamboji.qca.qualcomm.com> (sfid-20150312_133712_567771_02038D5A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> My recent patch `ath10k: fix broken traffic for
> 802.1x in client mode` introduced a regression on
> WPA crypto. All keys were treated as if they were
> WEP which resulted in WPA being incorrectly
> installed to fw/hw and subsequently no traffic.
>
> Reported-by: Marek Puzyniak <marek.puzyniak@tieto.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied. But I added the commit id to the log.

-- 
Kalle Valo
