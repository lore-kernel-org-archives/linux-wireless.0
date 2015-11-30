Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:10762 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbbK3PFz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2015 10:05:55 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Peter Oh <poh@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix board data fetch error message
References: <1448040794-1139-1-git-send-email-poh@qca.qualcomm.com>
Date: Mon, 30 Nov 2015 17:05:40 +0200
In-Reply-To: <1448040794-1139-1-git-send-email-poh@qca.qualcomm.com> (Peter
	Oh's message of "Fri, 20 Nov 2015 09:33:14 -0800")
Message-ID: <8737vnjznf.fsf@kamboji.qca.qualcomm.com> (sfid-20151130_160558_414240_7FEDFAB3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@qca.qualcomm.com> writes:

> The error message order of board data fetch is board info,
> directory, and then file name, hence place print arguments
> in the order.
>
> Fixes: 0a51b343abfe ("ath10k: add board 2 API support")
> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo
