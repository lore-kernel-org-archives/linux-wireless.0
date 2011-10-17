Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10747 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab1JQQuF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Oct 2011 12:50:05 -0400
Message-ID: <4E9C5CB4.3070204@qca.qualcomm.com> (sfid-20111017_185010_468004_8E855390)
Date: Mon, 17 Oct 2011 19:49:56 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Sangwook Lee <sangwook.lee@linaro.org>
CC: <linux-wireless@vger.kernel.org>, <patches@linaro.org>
Subject: Re: [PATCH 0/5] ath6kl: Add SDIO polling method for debugging
References: <1318596646-19495-1-git-send-email-sangwook.lee@linaro.org>
In-Reply-To: <1318596646-19495-1-git-send-email-sangwook.lee@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/14/2011 03:50 PM, Sangwook Lee wrote:
> Add SDIO polling method based user defined intevals
> At initial development stage, when SDIO irqs problem happen,
> We can use this funtionality for debugging.
> This is only tested with AR6003 HW2.0

Thank you for the patches. Unfortunately I can't take them to ath6kl.git
because this is just a workaround for the problem of interrupts
disappearing. Instead we need to find the real fix, be it in ath6kl,
sdio controller or hardware.

Kalle
