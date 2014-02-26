Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2921 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaBZQkH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 11:40:07 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <greearb@candelatech.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix sta_rc_update for non-ap iftype
References: <CA+BoTQmNdn3ELFRyiMwRE=nq5XukvSy2m7BNoqXnoz95JuDYOw@mail.gmail.com>
	<1392795187-2870-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 26 Feb 2014 18:40:02 +0200
In-Reply-To: <1392795187-2870-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 19 Feb 2014 08:33:07 +0100")
Message-ID: <87vbw1ltel.fsf@kamboji.qca.qualcomm.com> (sfid-20140226_174012_773916_4CE15645)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The arsta structure wasn't initialized for
> non-ap interfaces. This should fix related
> warnings/crashes.
>
> Reported-By: Ben Greear <greearb@candelatech.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
