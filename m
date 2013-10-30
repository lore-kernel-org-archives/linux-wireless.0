Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9925 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab3J3Jxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 05:53:33 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/2] ath10k: memory leak fixes
References: <1382941094-3291-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 30 Oct 2013 11:53:24 +0200
In-Reply-To: <1382941094-3291-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 28 Oct 2013 07:18:12 +0100")
Message-ID: <87ppqn6q5n.fsf@kamboji.qca.qualcomm.com> (sfid-20131030_105338_895060_19971A63)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Michal Kazior (2):
>   ath10k: plug memory leak in wmi mgmt tx worker
>   ath10k: plug memory leak on beacon tx

Thanks, both patches applied.

-- 
Kalle Valo
