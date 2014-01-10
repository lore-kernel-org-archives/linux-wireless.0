Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51106 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaAJJxz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jan 2014 04:53:55 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/3] ath10k: firmware dbglog and debug print events
References: <20140103105718.13474.70922.stgit@potku.adurom.net>
Date: Fri, 10 Jan 2014 11:53:51 +0200
In-Reply-To: <20140103105718.13474.70922.stgit@potku.adurom.net> (Kalle Valo's
	message of "Fri, 03 Jan 2014 12:59:13 +0200")
Message-ID: <87ob3k9n80.fsf@kamboji.qca.qualcomm.com> (sfid-20140110_105418_078069_F78F2071)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Here are two new interfaces, dbglog and debug print events, to help with
> firmware debugging on ath10k. Please review.
>
> ---
>
> Kalle Valo (3):
>       ath10k: handle WMI debug print events
>       ath10k: add trace event for WMI_DEBUG_MESG_EVENTID
>       ath10k: add debugfs file to control firmware dbglog

All three applied.

-- 
Kalle Valo
