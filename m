Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:3936 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab1GMEau (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 00:30:50 -0400
Subject: Re: [PATCH 11/24] ath6kl: add htc.c
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	gregkh@suse.de
In-Reply-To: <20110713013444.8517.89603.stgit@localhost6.localdomain6>
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6>
	 <20110713013444.8517.89603.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jul 2011 21:30:49 -0700
Message-ID: <1310531449.1143.29.camel@Joe-Laptop> (sfid-20110713_063052_168601_C67639AF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-07-13 at 04:34 +0300, Kalle Valo wrote: 
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
[] 
> +static void htc_tx_comp_update(struct htc_target *target,
> +			       struct htc_endpoint *endpoint,
> +			       struct htc_packet *packet)
> +{
[] 
> 	ath6kl_dbg(ATH6KL_DBG_HTC_SEND, "ctxt:0x%lx dist:0x%lx\n",
> +		(unsigned long) target->cred_dist_cntxt,
> +		(unsigned long *) &target->cred_dist_list);

compiler warning?


