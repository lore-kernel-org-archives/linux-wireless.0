Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24170 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab2AaTOk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 14:14:40 -0500
Message-ID: <4F283D85.1080907@qca.qualcomm.com> (sfid-20120131_201443_914557_52A3D710)
Date: Tue, 31 Jan 2012 21:14:13 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Santosh Sajjan <ssajjan@codeaurora.org>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Workaround to support Deep Sleep with MSM.
References: <1327953746-5133-1-git-send-email-kvalo@qca.qualcomm.com>
In-Reply-To: <1327953746-5133-1-git-send-email-kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/30/2012 10:02 PM, Kalle Valo wrote:
> From: Santosh Sajjan <ssajjan@codeaurora.org>
> 
> Set the host pm flag MMC_PM_WAKE_SDIO_IRQ to allow host
> to disable the sdc2_clk and sdc2_h_clk,so that the MSM device
> enter into TCXO shutdown.
> 
> Signed-off-by: Santosh Sajjan <ssajjan@codeaurora.org>

Thanks, applied.

Kalle
