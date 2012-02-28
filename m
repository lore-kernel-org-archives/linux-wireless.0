Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44044 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328Ab2B1Hut (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 02:50:49 -0500
Message-ID: <4F4C8754.10400@qca.qualcomm.com> (sfid-20120228_085120_279873_4A8CC4CF)
Date: Tue, 28 Feb 2012 09:50:44 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 1/2] ath6kl: Make sure to allocate rx buffers after the
 endpoint connection
References: <1328886633-2823-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1328886633-2823-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/10/2012 05:10 PM, Vasanthakumar Thiagarajan wrote:
> Rx buffers should be allocated for control and best effort endpoints only
> after the enpoints connection is esablished. But this is done before the
> endpoint connection is complete, we don't even the control and BE endpoints
> that time. Move the buffer allocation after endpoint connection is over,
> after ath6kl_init_hw_start(). Found in review, never seen any real issue
> with this.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks, both patches applied.

Kalle
