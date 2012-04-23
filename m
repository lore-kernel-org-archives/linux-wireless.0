Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3099 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab2DWL1J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 07:27:09 -0400
Message-ID: <4F953C88.3030609@qca.qualcomm.com> (sfid-20120423_132742_118421_2717E70F)
Date: Mon, 23 Apr 2012 14:27:04 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Ming Jiang <mjiang@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <rmani@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath6kl clear the MMC_PM_KEEP_POWER for cutpower case
References: <1334712304-12666-1-git-send-email-mjiang@qca.qualcomm.com>
In-Reply-To: <1334712304-12666-1-git-send-email-mjiang@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/18/2012 04:25 AM, Ming Jiang wrote:
> ath6kl: If wow deepsleep pno suspend failure driver will choose cutpower.
> in this scenario MMC_PM_KEEP_POWER should be cleared so that mmc will power
> off the ar6000
> 
> Signed-off-by: Ming Jiang <mjiang@qca.qualcomm.com>

Thanks, applied. But I removed extra parenthesis.

Kalle
