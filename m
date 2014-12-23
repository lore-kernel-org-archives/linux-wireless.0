Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19053 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaLWPZi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 10:25:38 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Peter Oh <poh@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: set phymode to 11b when NO_OFDM flag set
References: <1418926380-22206-1-git-send-email-poh@qca.qualcomm.com>
Date: Tue, 23 Dec 2014 17:25:28 +0200
In-Reply-To: <1418926380-22206-1-git-send-email-poh@qca.qualcomm.com> (Peter
	Oh's message of "Thu, 18 Dec 2014 10:13:00 -0800")
Message-ID: <87bnmue6c7.fsf@kamboji.qca.qualcomm.com> (sfid-20141223_162541_394681_BAD0E1F4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@qca.qualcomm.com> writes:

> phymode should use 11b only if NO_OFDM flags is set.
> Hence check up channel flag for NO_OFDM and set to
> 11b.
>
> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
