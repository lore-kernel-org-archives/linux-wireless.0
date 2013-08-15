Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:37417 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108Ab3HONKX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Aug 2013 09:10:23 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/3] ath10k: add support for HTT 3.0
References: <1375949298-7159-1-git-send-email-michal.kazior@tieto.com>
	<1376036014-29707-1-git-send-email-michal.kazior@tieto.com>
	<1376036014-29707-4-git-send-email-michal.kazior@tieto.com>
Date: Thu, 15 Aug 2013 16:10:04 +0300
In-Reply-To: <1376036014-29707-4-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 9 Aug 2013 10:13:34 +0200")
Message-ID: <878v0314nn.fsf@kamboji.qca.qualcomm.com> (sfid-20130815_151029_222864_165CC3F6)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> New firmware comes with new HTT protocol version.
> In 3.0 the separate mgmt tx command has been
> removed. All traffic is to be pushed through data
> tx (tx_frm) command with a twist - FW seems to not
> be able (yet?) to access tx fragment table so for
> manamgement frames frame pointer is passed
> directly.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Because I dropped patch 1 this patch had conflicts. I tried to be extra
careful, but please double check my conflict resolution.

-- 
Kalle Valo
