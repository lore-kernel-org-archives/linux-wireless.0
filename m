Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43524 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab3LPPnQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 10:43:16 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/3] ath10k: fix host corruption
References: <1386858261-16037-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 16 Dec 2013 17:43:10 +0200
In-Reply-To: <1386858261-16037-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 12 Dec 2013 15:24:18 +0100")
Message-ID: <874n68g5td.fsf@kamboji.qca.qualcomm.com> (sfid-20131216_164319_210807_BFC48A05)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This patchset aims at fixing (or at least
> reducing) the frequency of a (apparently) strange
> HW bug.
>
> The bug happens in some workloads with different
> frequency with different hardware spinoffs. It is
> triggered by a cold reset after HW/FW has been
> excercised with some work.
>
> On x86 this could be a hang, on AP135 it is a data
> bus error.
>
>
> Michal Kazior (3):
>   ath10k: fix device initialization routine
>   ath10k: zero device DRAM to avoid host hangs
>   ath10k: zero CE config upon deinit

Let's put these patches on hold for now while we investigate more about
this problem.

-- 
Kalle Valo
