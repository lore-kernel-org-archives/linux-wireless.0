Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20554 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758716AbcCDIoF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 03:44:05 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Fix sanity check on enabling btcoex via debugfs
Date: Fri, 4 Mar 2016 08:43:59 +0000
Message-ID: <87si06y6nm.fsf@kamboji.qca.qualcomm.com> (sfid-20160304_094411_379219_7321CE63)
References: <1456212516-3989-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1456212516-3989-1-git-send-email-mohammed@qca.qualcomm.com>
	(Mohammed Shafi Shajakhan's message of "Tue, 23 Feb 2016 12:58:36	+0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> writes:

> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
>
> First check for the device state before enabling / disabling
> btcoex, also return a proper error value. Enabling / disabling
> btcoex ideally does a f/w + ath10k_core_restart so the checks
> that are applicable for 'simulate_fw_crash' shall be applicable
> for this as well
>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo