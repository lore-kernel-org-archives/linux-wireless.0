Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57547 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbcCWMJf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2016 08:09:35 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "michal.kazior@tieto.com" <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/2] ath10k: fix tx hangs
Date: Wed, 23 Mar 2016 12:09:15 +0000
Message-ID: <87h9fxflat.fsf@kamboji.qca.qualcomm.com> (sfid-20160323_130938_713437_05F0F113)
References: <1458208265-16715-1-git-send-email-michal.kazior@tieto.com>
In-Reply-To: <1458208265-16715-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 17 Mar 2016 10:51:03 +0100")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> My recent wake-tx-queue/pull-push related patches
> introduced a regression that can cause tx to hang
> under certain circumstances.
>
>
> Michal Kazior (2):
>   ath10k: fix tx hang
>   ath10k: fix pull-push tx threshold handling

Both applied, thanks.

-- 
Kalle Valo