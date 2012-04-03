Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13191 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab2DCSrh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 14:47:37 -0400
Message-ID: <4F7B45C1.3030804@qca.qualcomm.com> (sfid-20120403_204741_788647_C4160E37)
Date: Tue, 3 Apr 2012 21:47:29 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>,
	<ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	PingYang Zhang <pingzhan@qca.qualcomm.com>
Subject: Re: [PATCH 1/2] ath6kl: Use vmalloc instead of kmalloc for fw
References: <1332942686-6965-1-git-send-email-nataraja@qca.qualcomm.com>	 <4F7B411D.5070903@qca.qualcomm.com> <1333478499.26079.67.camel@joe2Laptop>
In-Reply-To: <1333478499.26079.67.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/03/2012 09:41 PM, Joe Perches wrote:
> On Tue, 2012-04-03 at 21:27 +0300, Kalle Valo wrote:
>> On 03/28/2012 04:51 PM, Vivek Natarajan wrote:
>>> Sometimes it has been observed that allocating a contiguous memory
>>> of more than 100K fails with kmalloc. This has been modified to
>>> use vmalloc instead.
>>>
>>> Signed-off-by: PingYang Zhang <pingzhan@qca.qualcomm.com>
>>> Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
>>
>> Thanks, both patches applied.
> 
> Because the vmalloc space is limited, this should try
> kmalloc first and only on failure try vmalloc.

Thanks, I didn't know that.

Vivek, I would gladly take a followup patch which does what Joe suggests.

Kalle
