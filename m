Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59910 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab2ABRtq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 12:49:46 -0500
Message-ID: <4F01DA75.3060602@qca.qualcomm.com> (sfid-20120102_184950_429429_2B8248DB)
Date: Mon, 2 Jan 2012 18:25:25 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Rishi Panjwani <rpanjwan@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath6kl: Support for TCP checksum offload to firmware
References: <1325024880-22364-1-git-send-email-rpanjwan@qca.qualcomm.com>
In-Reply-To: <1325024880-22364-1-git-send-email-rpanjwan@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/28/2011 12:28 AM, Rishi Panjwani wrote:
> The change enables offloading TCP checksum calculation to firmware.
> There are still some issues with the checksum offload so better to
> disable it by default until the issues are resolved.
> 
> To enable TCP checksum offload for tx and rx paths, use
> the ethtool as follows:
> ethtool -K <interface> tx on
> ethtool -K <interface> rx on
> 
> To disable TCP checksum offload, for tx and rx paths, use
> the ethtool as follows:
> ethtool -K <interface> tx off
> ethtool -K <interface> rx off
> 
> Signed-off-by: Rishi Panjwani <rpanjwan@qca.qualcomm.com>

Thanks, applied with some minor indentation changes.

Kalle
