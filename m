Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21784 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757092Ab2E3IQB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 04:16:01 -0400
Message-ID: <4FC5D73A.9040807@qca.qualcomm.com> (sfid-20120530_101607_534593_1E001BAE)
Date: Wed, 30 May 2012 11:15:54 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Etay Luz <eluz@qca.qualcomm.com>
Subject: Re: [PATCH] ath6kl: support changing dtim period on AP mode
References: <1338363787-12314-1-git-send-email-kvalo@qca.qualcomm.com> <1338365645.28696.0.camel@joe2Laptop>
In-Reply-To: <1338365645.28696.0.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/30/2012 11:14 AM, Joe Perches wrote:
> On Wed, 2012-05-30 at 10:43 +0300, Kalle Valo wrote:
>> +	ret = ath6kl_wmi_ap_set_dtim_cmd(ar->wmi, info->dtim_period);
>> +
>> +	/* ignore error, just print a warning and continue normally */
>> +	if (ret)
>> +		ath6kl_warn("Failed to set dtim_period in beacon: %d", ret);
> 
> missing newline termination

Oh yeah, I missed that. Thanks.

I haven't pushed the patch so I'll just amend the fix.

Kalle
