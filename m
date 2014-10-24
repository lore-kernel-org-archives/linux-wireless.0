Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60429 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494AbaJXNeq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 09:34:46 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/2] ath10k: minor htt tracing fix
References: <1413899700-10717-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 24 Oct 2014 16:34:22 +0300
In-Reply-To: <1413899700-10717-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 21 Oct 2014 15:54:58 +0200")
Message-ID: <87y4s5mw0x.fsf@kamboji.qca.qualcomm.com> (sfid-20141024_153449_407691_1BA4921E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> I've just noticed that rx_desc tracing is somewhat
> wrong. This attempts to fix it and since the trace
> function prototype changes I re-use some tracing
> code as well.
>
>
> Michal Kazior (2):
>   ath10k: remove tsf argument from rx_desc tracing
>   ath10k: re-use trace class

Thanks, both patches applied.

-- 
Kalle Valo
