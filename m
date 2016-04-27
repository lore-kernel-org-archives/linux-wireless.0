Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37526 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbcD0Mx1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2016 08:53:27 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC: "Liu, Alan" <alanliu@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add max_tx_power for QCA6174 WLAN.RM.2.0 firmware
Date: Wed, 27 Apr 2016 12:53:23 +0000
Message-ID: <87inz3w6v1.fsf@kamboji.qca.qualcomm.com> (sfid-20160427_145345_501453_46C660EE)
References: <1461608670-15386-1-git-send-email-kvalo@qca.qualcomm.com>
In-Reply-To: <1461608670-15386-1-git-send-email-kvalo@qca.qualcomm.com> (Kalle
	Valo's message of "Mon, 25 Apr 2016 21:24:30 +0300")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> From: Alan Liu <alanliu@qca.qualcomm.com>
>
> QCA6174 WLAN.RM.2.0 firmware uses max_tx_power instead of using max_reg_power
> to set transmission power. The tx power was about -50dbm, after applying this
> change, it become -32dbm.
>
> Signed-off-by: Alan Liu <alanliu@qca.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo