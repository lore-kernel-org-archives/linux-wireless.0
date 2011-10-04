Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41828 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab1JDILk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 04:11:40 -0400
Message-ID: <4E8ABF12.9080607@qca.qualcomm.com> (sfid-20111004_101210_588402_7B2DDD1C)
Date: Tue, 4 Oct 2011 11:08:50 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: "Thiagarajan, Vasanthakumar" <vthiagar@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/5] ath6kl: Fix possible race in accessing bounce buffer
References: <1317390526-3442-1-git-send-email-vthiagar@qca.qualcomm.com>,<1317390526-3442-4-git-send-email-vthiagar@qca.qualcomm.com> <EDA962D9696870498097087E0373E7710B5AA5@nasanexd01e.na.qualcomm.com>
In-Reply-To: <EDA962D9696870498097087E0373E7710B5AA5@nasanexd01e.na.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/03/2011 06:52 PM, Thiagarajan, Vasanthakumar wrote:
> 
> ________________________________________
> From: Thiagarajan, Vasanthakumar
> Sent: Friday, September 30, 2011 7:18 PM
> To: Valo, Kalle
> Cc: linux-wireless@vger.kernel.org
> Subject: [PATCH 4/5] ath6kl: Fix possible race in accessing bounce buffer
> 
> There is only one bounce buffer (ar_sdio->dma_buffer) which is used
> for both read and write without any protection. Fix this race by
> allocating bounce buffer every time when it is needed.
> 
> As I have never seen any race in bounce buffer practically during my testing,
> this patch can be dropped instead of making the code complex for no reason.

Heh, we got lucky again. I had applied the patches but forgot to push
them to github. So I was able to drop patches 4 and 5.

Kalle
