Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52500 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbZAYT7k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2009 14:59:40 -0500
Subject: Re: [PATCH] orinoco: checkpatch cleanup
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200901252254.32137.arvidjaar@mail.ru> (sfid-20090125_205535_658867_59D1A796)
References: <200901252254.32137.arvidjaar@mail.ru>
	 (sfid-20090125_205535_658867_59D1A796)
Content-Type: text/plain
Date: Sun, 25 Jan 2009 20:59:35 +0100
Message-Id: <1232913575.3837.16.camel@johannes.local> (sfid-20090125_205945_822811_A04E5B9C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-01-25 at 22:54 +0300, Andrey Borzenkov wrote:

> @@ -60,7 +60,8 @@ airport_suspend(struct macio_dev *mdev, pm_message_t 
> state)
>  	orinoco_unlock(priv, &flags);
>  
>  	disable_irq(dev->irq);
> -	pmac_call_feature(PMAC_FTR_AIRPORT_ENABLE, macio_get_of_node(mdev), 0, 
> 0);
> +	pmac_call_feature(PMAC_FTR_AIRPORT_ENABLE,
> +			  macio_get_of_node(mdev), 0, 0);

unfortunately, your patch was line-wrapped. Cf.
Documentation/email-clients.txt

johannes

