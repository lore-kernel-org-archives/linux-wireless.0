Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:48527 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbaB0Qmm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 11:42:42 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: skip management frames in HTT path
References: <1393311399-8070-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Thu, 27 Feb 2014 18:42:36 +0200
In-Reply-To: <1393311399-8070-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Tue, 25 Feb 2014 07:56:39 +0100")
Message-ID: <87d2i8eccj.fsf@kamboji.qca.qualcomm.com> (sfid-20140227_174246_205562_4C5C2013)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> After we pass frames with INV_PEER to upper layer in patch:
>
> ath10k: pass frames with invalid peer status to upper layer
>
> we could pass some management frames (in case INVALID_PEER
> and MGMT_CTRL) twice to upper layer, once via WMI and once
> via HTT. Next we could handle assoc request twice. This
> patch remove such regression.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Thanks, applied.

-- 
Kalle Valo
