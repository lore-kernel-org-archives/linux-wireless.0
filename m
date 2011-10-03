Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60284 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab1JCLKs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 07:10:48 -0400
Message-ID: <4E899830.2070506@qca.qualcomm.com> (sfid-20111003_131051_122030_45ACEBBB)
Date: Mon, 3 Oct 2011 14:10:40 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2 3/5] ath6kl: Claim sdio function only at appropriate
 places
References: <1317399419-3929-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1317399419-3929-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/30/2011 07:16 PM, Vasanthakumar Thiagarajan wrote:
> There are places where tx_complete callbacks are called with
> claiming the sdio function. It is not necessary to hold the
> sdio func for longer. This may even affect the host side power
> save, if it is supported by the controller.

Applied, thanks.

But in the future, please resend the whole patchset even when you modify
just one patch. Resending invidividual patches from a patchset is error
prone and most likely I will apply the wrong patch.

Kalle
