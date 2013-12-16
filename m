Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:24326 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab3LPNOL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 08:14:11 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: handle TKIP MIC error correctly
References: <1386938656-5280-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Mon, 16 Dec 2013 15:14:06 +0200
In-Reply-To: <1386938656-5280-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Fri, 13 Dec 2013 13:44:16 +0100")
Message-ID: <871u1dgcpt.fsf@kamboji.qca.qualcomm.com> (sfid-20131216_141415_688794_386DBA3B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> We should check MIC error flag base on
> rx_attention, to have consistent status
> of MIC failure and FCS error.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Thanks, applied.

-- 
Kalle Valo
