Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10136 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab2CTJga (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 05:36:30 -0400
Message-ID: <4F684F98.4070705@qca.qualcomm.com> (sfid-20120320_103633_716549_9E2A6D51)
Date: Tue, 20 Mar 2012 11:36:24 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Add ARP offload related statistic info in tgt_stats
References: <1331893496-18098-1-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1331893496-18098-1-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/16/2012 12:24 PM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> Firmware reports the below ARP offload related information
> while sending the target statistic event to the host.
> 
>      * Number of ARP packets received.
>      * Number of packets matched with the device IP addr.
>      * Number of ARP response packet sent to the remote.
> 
> This patch adds the additional debug prints in debugfs
> entry tgt_stats. It will be useful to know the ARP offload
> execution status.
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>

Thanks, applied.

Kalle
