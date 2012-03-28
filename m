Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26577 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2C1Nx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 09:53:26 -0400
Message-ID: <4F7317D2.3010405@qca.qualcomm.com> (sfid-20120328_155329_843993_58B76071)
Date: Wed, 28 Mar 2012 16:53:22 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Bala Shanmugam <bkamatch@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Set background scan period.
References: <1332830852-2348-1-git-send-email-bkamatch@qca.qualcomm.com>
In-Reply-To: <1332830852-2348-1-git-send-email-bkamatch@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/27/2012 09:47 AM, Bala Shanmugam wrote:
> After connect command, send scan params WMI command to
> set background scan period. If period value is zero
> send 0xffff as bg scan period to disable bg scan.
> Set default bg scan period to be 60 seconds if
> not specified.
> 
> This patch depends on below patch
> cfg80211: Add background scan period attribute.
> 
> Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>

Thanks, applied.

Kalle
