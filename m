Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38973 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab2B0R0u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 12:26:50 -0500
Message-ID: <4F4BBCD6.3060509@qca.qualcomm.com> (sfid-20120227_182654_433581_DEECF69F)
Date: Mon, 27 Feb 2012 19:26:46 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 1/2] ath6kl: Fix missing release of semaphore in ath6kl_stop_txrx()
References: <1329231780-18929-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1329231780-18929-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/14/2012 05:02 PM, Vasanthakumar Thiagarajan wrote:
> This fixes smatch warning "inconsistent returns sem:&ar->sem".
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks, both patches applied.

Kalle
