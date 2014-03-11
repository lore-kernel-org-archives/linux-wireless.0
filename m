Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:64486 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077AbaCKKWa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 06:22:30 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: allow the supported rate change by reassociate peer
References: <1394013026-8426-1-git-send-email-yeohchunyeow@gmail.com>
Date: Tue, 11 Mar 2014 12:22:08 +0200
In-Reply-To: <1394013026-8426-1-git-send-email-yeohchunyeow@gmail.com>
	(Chun-Yeow Yeoh's message of "Wed, 5 Mar 2014 17:50:26 +0800")
Message-ID: <8738iphw6n.fsf@kamboji.qca.qualcomm.com> (sfid-20140311_112239_943076_21E51F65)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chun-Yeow Yeoh <yeohchunyeow@gmail.com> writes:

> IBSS mode requires the changing of supported rate. Do this
> by reassociate the peer. The investigation shows that if move
> from legacy to HT, the rate control won't work after changing
> the supported rate. But once changing the supported rate to HT,
> user can assign the TxRate in HT mode.
>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>

Thanks, applied.

-- 
Kalle Valo
