Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:30138 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab3KXNuN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 08:50:13 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath10k: use nss provided by mac80211
References: <1385126819-15311-1-git-send-email-michal.kazior@tieto.com>
	<1385126819-15311-2-git-send-email-michal.kazior@tieto.com>
Date: Sun, 24 Nov 2013 15:50:07 +0200
In-Reply-To: <1385126819-15311-2-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 22 Nov 2013 14:26:57 +0100")
Message-ID: <87k3fxsycw.fsf@kamboji.qca.qualcomm.com> (sfid-20131124_145018_721133_35C02559)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Calculating STA NSS just from the rateset is not
> the greatest idea. The NSS could be possibly
> influenced by other things that only mac80211
> knows about.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Is there a bug which this patch fixes or what motivated you to do this?

-- 
Kalle Valo
