Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14384 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab1JJExQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 00:53:16 -0400
Date: Mon, 10 Oct 2011 10:22:13 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/5] ath6kl: Fix possible race in accessing bounce
	buffer
Message-ID: <20111010045211.GB4637@vasanth-laptop> (sfid-20111010_065329_618858_DFB86791)
References: <EDA962D9696870498097087E0373E7710B5AA5@nasanexd01e.na.qualcomm.com> <4E8ABF12.9080607@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4E8ABF12.9080607@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 04, 2011 at 11:08:50AM +0300, Kalle Valo wrote:
> On 10/03/2011 06:52 PM, Thiagarajan, Vasanthakumar wrote:
> > 
> > ________________________________________
> > From: Thiagarajan, Vasanthakumar
> > Sent: Friday, September 30, 2011 7:18 PM
> > To: Valo, Kalle
> > Cc: linux-wireless@vger.kernel.org
> > Subject: [PATCH 4/5] ath6kl: Fix possible race in accessing bounce buffer
> > 
> > There is only one bounce buffer (ar_sdio->dma_buffer) which is used
> > for both read and write without any protection. Fix this race by
> > allocating bounce buffer every time when it is needed.
> > 
> > As I have never seen any race in bounce buffer practically during my testing,
> > this patch can be dropped instead of making the code complex for no reason.
> 
> Heh, we got lucky again. I had applied the patches but forgot to push
> them to github. So I was able to drop patches 4 and 5.

Thanks a lot.

Vasanth
