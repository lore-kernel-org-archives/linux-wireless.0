Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39650 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135AbbJMNAd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 09:00:33 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Jeff Johnson <jjohnson@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Cleanup ath10k_mac_register() error handling
References: <1444320953-2154-1-git-send-email-jjohnson@qca.qualcomm.com>
Date: Tue, 13 Oct 2015 16:00:19 +0300
In-Reply-To: <1444320953-2154-1-git-send-email-jjohnson@qca.qualcomm.com>
	(Jeff Johnson's message of "Thu, 8 Oct 2015 09:15:53 -0700")
Message-ID: <87io6aq5y4.fsf@kamboji.qca.qualcomm.com> (sfid-20151013_150037_485207_CC7AAA07)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jeff Johnson <jjohnson@qca.qualcomm.com> writes:

> The logic in the error-handling path of ath10k_mac_register() is
> divergent from the logic in ath10k_mac_unregister().  Update the
> ath10k_mac_register() error handling logic to align with the
> ath10k_mac_unregister() logic.
>
> Signed-off-by: Jeff Johnson <jjohnson@qca.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo
