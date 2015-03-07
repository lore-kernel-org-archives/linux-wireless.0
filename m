Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63140 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195AbbCGHzV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2015 02:55:21 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix ap u-apsd cmd on qca6174 w/ wmi-tlv
References: <1424860776-11668-1-git-send-email-michal.kazior@tieto.com>
Date: Sat, 7 Mar 2015 09:55:13 +0200
In-Reply-To: <1424860776-11668-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 25 Feb 2015 11:39:36 +0100")
Message-ID: <8761ad1btq.fsf@kamboji.qca.qualcomm.com> (sfid-20150307_085524_429617_C8F28247)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The command was truncated so the parameter value
> was seen in fw as 0. This caused U-APSD enabled
> stations to be misconfigured and mistreated by AP.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
