Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:3921 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab1GME2y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 00:28:54 -0400
Subject: Re: [PATCH 01/24] ath6kl: add bmi.c
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	gregkh@suse.de
In-Reply-To: <20110713013300.8517.98566.stgit@localhost6.localdomain6>
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6>
	 <20110713013300.8517.98566.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jul 2011 21:28:53 -0700
Message-ID: <1310531333.1143.25.camel@Joe-Laptop> (sfid-20110713_062858_064870_43F53E30)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-07-13 at 04:33 +0300, Kalle Valo wrote: 
> diff --git a/drivers/net/wireless/ath/ath6kl/bmi.c b/drivers/net/wireless/ath/ath6kl/bmi.c
[] 
> +			ath6kl_err("Unable to decrement the command "
> +				   "credit count register: %d\n", ret);

I think all of these ath6kl_<level> uses in all the patches
should coalesce formats that are split across multiple lines.
This helps grepping the sources for a specific dmesg.

			ath6kl_err("Unable to decrement the command credit count register: %d\n",
				   ret);
[]
> +			ath6kl_err("unable to read target info "
> +				   "byte count: %d\n", ret);

			ath6kl_err("unable to read target info byte count: %d\n",
				   ret);
[]
> +			ath6kl_err("Unable to read target info "
> +				   "(%d bytes): %d\n",
> +				   targ_info->byte_count, ret);

			ath6kl_err("Unable to read target info %d bytes): %d\n",
				   targ_info->byte_count, ret);

etc...



