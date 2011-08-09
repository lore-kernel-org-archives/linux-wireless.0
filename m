Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36238 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab1HIN6c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 09:58:32 -0400
Message-ID: <4E413CEC.4050704@qca.qualcomm.com> (sfid-20110809_155835_991376_513E0BDF)
Date: Tue, 9 Aug 2011 16:58:04 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Include scatterlist.h in hif.h to fix compilation
 error
References: <1312889254-30996-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1312889254-30996-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/09/2011 02:27 PM, Vasanthakumar Thiagarajan wrote:
> drivers/net/wireless/ath/ath6kl/hif.h:194: error: array type has incomplete element type
> commit b7f080cfe223b3b7424872639d153695615a9255 exposes this issue. scatterlist.h used to
> get included from dma-mapping.h<-dmaengine.h<-skbuff.h.

Thanks for the patch. I noticed the same when creating the ath6kl git
tree and I have fixed with a similar patch there. I'm planning to make
that tree available later today.

Kalle
