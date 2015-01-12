Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:60298 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbbALL4b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 06:56:31 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Enable RX batching
References: <1419834084-11859-1-git-send-email-sujith@msujith.org>
Date: Mon, 12 Jan 2015 13:56:20 +0200
In-Reply-To: <1419834084-11859-1-git-send-email-sujith@msujith.org> (Sujith
	Manoharan's message of "Mon, 29 Dec 2014 11:51:24 +0530")
Message-ID: <87h9vwdxgb.fsf@kamboji.qca.qualcomm.com> (sfid-20150112_125635_153204_ABA6E4DB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> This feature allows the FW to batch RX indications,
> reducing the rate of host interrupt generation, which
> in turn reduces CPU load. Currently, this is enabled
> only for the 10.2 firmware.
>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
