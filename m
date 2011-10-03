Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28241 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab1JCLjK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 07:39:10 -0400
Date: Mon, 3 Oct 2011 17:08:14 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2 3/5] ath6kl: Claim sdio function only at appropriate
	places
Message-ID: <20111003113812.GA24335@vasanth-laptop> (sfid-20111003_133914_256947_56F77655)
References: <1317399419-3929-1-git-send-email-vthiagar@qca.qualcomm.com> <4E899830.2070506@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4E899830.2070506@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 03, 2011 at 02:10:40PM +0300, Kalle Valo wrote:
> On 09/30/2011 07:16 PM, Vasanthakumar Thiagarajan wrote:
> > There are places where tx_complete callbacks are called with
> > claiming the sdio function. It is not necessary to hold the
> > sdio func for longer. This may even affect the host side power
> > save, if it is supported by the controller.
> 
> Applied, thanks.
> 
> But in the future, please resend the whole patchset even when you modify
> just one patch. Resending invidividual patches from a patchset is error
> prone and most likely I will apply the wrong patch.

Sure, thanks.

Vasanth
