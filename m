Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22570 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbaBZRQG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 12:16:06 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: skip management frames in HTT path
References: <1393311399-8070-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Wed, 26 Feb 2014 19:16:01 +0200
In-Reply-To: <1393311399-8070-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Tue, 25 Feb 2014 07:56:39 +0100")
Message-ID: <87a9ddlrqm.fsf@kamboji.qca.qualcomm.com> (sfid-20140226_181611_584543_8753822A)
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

I saw a conflict and also did some commit log cleanup. Please check:

https://github.com/kvalo/ath/commit/dd0063fba4434d22fb8a6e6d79bf23cc36f6916a

-- 
Kalle Valo
