Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51588 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbcCHNcs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 08:32:48 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <wnhuang@google.com>
Subject: Re: [PATCH v2] mwifiex: Empty Tx queue during suspend
References: <1457436317-15477-1-git-send-email-akarwar@marvell.com>
Date: Tue, 08 Mar 2016 15:32:43 +0200
In-Reply-To: <1457436317-15477-1-git-send-email-akarwar@marvell.com>
	(Amitkumar Karwar's message of "Tue, 8 Mar 2016 03:25:17 -0800")
Message-ID: <87a8m9ksck.fsf@purkki.adurom.net> (sfid-20160308_143251_484536_BF9ECC5E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

> In cfg80211 suspend handler, stop the netif queue and
> wait until all the Tx queues become empty. Start the
> queues in resume handler.
>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

The changelog is missing, please always provide one.

-- 
Kalle Valo
