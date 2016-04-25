Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37022 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933389AbcDYSbv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2016 14:31:51 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Alan Liu <alanliu@qca.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v4] Add max_tx_power member to set max transmission power for WLAN.RM.2.0 firmware.
References: <1454618735-10153-1-git-send-email-alanliu@qca.qualcomm.com>
Date: Mon, 25 Apr 2016 21:31:46 +0300
In-Reply-To: <1454618735-10153-1-git-send-email-alanliu@qca.qualcomm.com>
	(Alan Liu's message of "Thu, 4 Feb 2016 12:45:35 -0800")
Message-ID: <87h9ep1qwd.fsf@kamboji.qca.qualcomm.com> (sfid-20160425_203205_555201_9AA902C6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alan Liu <alanliu@qca.qualcomm.com> writes:

> WLAN.RM.2.0 firmware use max_tx_power instead of using
> max_reg_power to set transmission power. The tx power was about -50dbm, after
>  applying this change, it become -32dbm.
>
> Signed-off-by: Alan Liu <alanliu@qca.qualcomm.com>

I resent this as:

ath10k: add max_tx_power for QCA6174 WLAN.RM.2.0 firmware

https://patchwork.kernel.org/patch/8931271/

-- 
Kalle Valo
