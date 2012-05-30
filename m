Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52443 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757153Ab2E3I0d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 04:26:33 -0400
Message-ID: <4FC5D9B4.6060803@qca.qualcomm.com> (sfid-20120530_102638_447897_B8B9BC39)
Date: Wed, 30 May 2012 11:26:28 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Etay Luz <eluz@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: support changing dtim period on AP mode
References: <1338363787-12314-1-git-send-email-kvalo@qca.qualcomm.com> <4FC5CFF6.2090101@qca.qualcomm.com>
In-Reply-To: <4FC5CFF6.2090101@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/30/2012 10:44 AM, Kalle Valo wrote:
> On 05/30/2012 10:43 AM, Kalle Valo wrote:
>> From: Etay Luz <eluz@qca.qualcomm.com>
>>
>> This patch adds support for dtim_period configuration in beacon.
>>
>> kvalo: add a comment about ignoring the error
>>
>> Signed-off-by: Etay Luz <eluz@qca.qualcomm.com>
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> 
> Applied, thanks.

Actually, I withdraw that. Joe found an issue and Vasanth privately
reported me about vif index problem.

I'll send v2 instead.

Kalle
