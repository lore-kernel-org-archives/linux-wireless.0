Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10373 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab3JHMXp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 08:23:45 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/2] ath10k: minor fixes
References: <1380867200-19714-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 8 Oct 2013 15:23:39 +0300
In-Reply-To: <1380867200-19714-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 4 Oct 2013 08:13:18 +0200")
Message-ID: <87vc18rlx0.fsf@kamboji.qca.qualcomm.com> (sfid-20131008_142348_456351_1815784C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The patchset fixes a compilation warning and a
> memory leak in FW loading code.
>
> Michal Kazior (2):
>   ath10k: fix printf format string
>   ath10k: fix possible memory leak in new FW loading

Both appplied, thanks for fixing my bugs :)

-- 
Kalle Valo
