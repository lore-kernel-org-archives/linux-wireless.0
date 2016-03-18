Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12013 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbcCRHuy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 03:50:54 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rmanohar@codeaurora.org" <rmanohar@codeaurora.org>
Subject: Re: [PATCH] ath10k: handle channel change htt event
Date: Fri, 18 Mar 2016 07:50:43 +0000
Message-ID: <87io0ki5rh.fsf@kamboji.qca.qualcomm.com> (sfid-20160318_085058_451832_EC746924)
References: <1457458043-9593-1-git-send-email-rmanohar@qti.qualcomm.com>
In-Reply-To: <1457458043-9593-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Tue, 8 Mar 2016 22:57:23 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Whenever firmware is configuring operating channel during scan or
> home channel, channel change event will be indicated to host. In some
> cases (device probe/ last vdev down), target will be configured to
> default channel whereas host is unaware of target's operating channel.
> This leads to packet drop due to unknown channel and kernel log will be
> filled up with "no channel configured; ignoring frame(s)!". Fix that
> by handling HTT_T2H_MSG_TYPE_CHAN_CHANGE event.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo