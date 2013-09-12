Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60475 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab3ILQVp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Sep 2013 12:21:45 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: delete struct ce_sendlist
References: <20130908153611.4572.43965.stgit@localhost6.localdomain6>
Date: Thu, 12 Sep 2013 19:21:43 +0300
In-Reply-To: <20130908153611.4572.43965.stgit@localhost6.localdomain6> (Kalle
	Valo's message of "Sun, 08 Sep 2013 18:36:11 +0300")
Message-ID: <871u4uf1t4.fsf@qca.qualcomm.com> (sfid-20130912_182148_189938_BF3069F6)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> struct ce_sendlist is useless as we always add just one buffer onto it.
> And most importantly, it's ugly as it doesn't use skb properly.
>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Applied.

-- 
Kalle Valo
