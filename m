Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45875 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaEYHow (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 May 2014 03:44:52 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	<apenwarr@gmail.com>
Subject: Re: [PATCH 3/3] ath10k: add explicit memory barrier for ring index update
References: <1400158139-13836-1-git-send-email-michal.kazior@tieto.com>
	<1400158139-13836-4-git-send-email-michal.kazior@tieto.com>
Date: Sun, 25 May 2014 10:44:46 +0300
In-Reply-To: <1400158139-13836-4-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 15 May 2014 14:48:59 +0200")
Message-ID: <87mwe6ti8h.fsf@kamboji.qca.qualcomm.com> (sfid-20140525_094455_784475_FF338484)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Avery reported he had some issues related to
> instructions being re-ordered on his ARM test
> system resulting in firmware crashes.
>
> This makes sure that data is in place before CE
> ring index is updated telling firmware it can
> fetch the data.
>
> Reported-By: Avery Pennarun <apenwarr@gmail.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

I have dropped this patch for now. Like I said before, let's first be
sure that all memory barrier issues are resolved and only then apply
this.

-- 
Kalle Valo
