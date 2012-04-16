Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57748 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab2DPGO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 02:14:29 -0400
Message-ID: <4F8BB8C1.2060107@qca.qualcomm.com> (sfid-20120416_081432_839644_23F45F88)
Date: Mon, 16 Apr 2012 09:14:25 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Ming Jiang <mjiang@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] Allow deepsleep_suspend function when wlan interface
 down
References: <1334322565-7893-1-git-send-email-mjiang@qca.qualcomm.com>
In-Reply-To: <1334322565-7893-1-git-send-email-mjiang@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/13/2012 04:09 PM, Ming Jiang wrote:
> ath6kl: after wlan interface down. WLAN_ENABLED flags will be cleared.
> deepsleep_suspend function will be blocked in this senario. This patch 
> allows deepsleep_suspend function when wlan interface down by removed 
> the WLAN_ENABLED flag checking
> 
> Signed-off-by: Ming Jiang <mjiang@qca.qualcomm.com>

Thanks, applied.

Kalle
