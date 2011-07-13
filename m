Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20478 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab1GMHIr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 03:08:47 -0400
Message-ID: <4E1D4479.8090201@qca.qualcomm.com> (sfid-20110713_090851_068365_AAF83D7A)
Date: Wed, 13 Jul 2011 10:08:41 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <linux-wireless@vger.kernel.org>, <devel@linuxdriverproject.org>,
	<gregkh@suse.de>
Subject: Re: [PATCH 01/24] ath6kl: add bmi.c
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6>	 <20110713013300.8517.98566.stgit@localhost6.localdomain6> <1310531333.1143.25.camel@Joe-Laptop>
In-Reply-To: <1310531333.1143.25.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/13/2011 07:28 AM, Joe Perches wrote:
> On Wed, 2011-07-13 at 04:33 +0300, Kalle Valo wrote: 
>> diff --git a/drivers/net/wireless/ath/ath6kl/bmi.c b/drivers/net/wireless/ath/ath6kl/bmi.c
> [] 
>> +			ath6kl_err("Unable to decrement the command "
>> +				   "credit count register: %d\n", ret);
> 
> I think all of these ath6kl_<level> uses in all the patches
> should coalesce formats that are split across multiple lines.
> This helps grepping the sources for a specific dmesg.
> 
> 			ath6kl_err("Unable to decrement the command credit count register: %d\n",
> 				   ret);

I agree, that would improve readibility. The reason why the lines were
split is because of checkpatch warnings. I could unsplit them but then
someone else might start complaining about high number checkpatch
warnings about long lines. So I really don't know what to do with them.

Kalle
