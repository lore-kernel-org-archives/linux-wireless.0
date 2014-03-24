Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:55724 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaCXJkd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 05:40:33 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 7/8] ath10k: improve way we play with attention flags
References: <1395394341-3958-1-git-send-email-janusz.dziedzic@tieto.com>
	<1395394341-3958-8-git-send-email-janusz.dziedzic@tieto.com>
Date: Mon, 24 Mar 2014 11:40:10 +0200
In-Reply-To: <1395394341-3958-8-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Fri, 21 Mar 2014 10:32:20 +0100")
Message-ID: <87mwgg6ikl.fsf@kamboji.qca.qualcomm.com> (sfid-20140324_104036_839087_97D6680F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Remove almost the same code, and do only once
> __le32_to_cpu() conversion.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

This patch introduces one checkpatch warning:

drivers/net/wireless/ath/ath10k/htt_rx.c:1209: CHECK: No space is necessary after a cast

-- 
Kalle Valo
