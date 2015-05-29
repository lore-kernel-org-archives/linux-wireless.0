Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34550 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbbE2Oll (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2015 10:41:41 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] ath10k: move cycle_count macro
In-Reply-To: <1432555579-18347-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 25 May 2015 14:06:17 +0200")
References: <1432282693-4553-1-git-send-email-michal.kazior@tieto.com>
	<1432555579-18347-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 29 May 2015 17:41:14 +0300
Message-ID: <87vbfbwinp.fsf@kamboji.qca.qualcomm.com> (sfid-20150529_164146_881056_FBD5034A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The macro isn't WMI specific. Instead it is
> related to hardware chip so move the macro
> accordingly. While at it document the magic value.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, all three applied.

-- 
Kalle Valo
