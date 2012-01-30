Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33564 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab2A3Th7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 14:37:59 -0500
Message-ID: <4F26F190.6060902@qca.qualcomm.com> (sfid-20120130_203805_648002_F52B956A)
Date: Mon, 30 Jan 2012 21:37:52 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH v3 0/4] Allow the user to define suspend mode
References: <1327923792-16408-1-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1327923792-16408-1-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/30/2012 01:43 PM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> This series of patch enables the user to specify the suspend mode 
> via module parameter (suspend_mode) while doing insmod of the driver.
> 
>    To select Cut Power mode:
>       insmod ath6kl_sdio.ko suspend_mode = 1
> 
>    To select Deep Sleep mode:
>       insmod ath6kl_sdio.ko suspend_mode = 2
> 
>    To select WOW suspend mode:
>       insmod ath6kl_sdio.ko suspend_mode = 3
> 
> Existing module param 'suspend_cutpower' variable is renamed to 
> 'suspend_mode' for this purspose.
> 
> Additionally, If the user doesn't provide any WOW patterns, 
> the default WOW patterns will be configured while going to
> WOW suspend mode.

Thanks, all four applied.

Kalle
