Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48751 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab2ARFyo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jan 2012 00:54:44 -0500
Message-ID: <4F165E3F.4090707@qca.qualcomm.com> (sfid-20120118_065449_013246_82C555EF)
Date: Wed, 18 Jan 2012 11:23:03 +0530
From: Raja Mani <rmani@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 1/2] ath6kl: Remove useless initialization in ath6kl_read_fwlogs()
References: <1326360708-9362-1-git-send-email-rmani@qca.qualcomm.com> <4F101B6D.2020405@qca.qualcomm.com>
In-Reply-To: <4F101B6D.2020405@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 13 January 2012 05:24 PM, Kalle Valo wrote:
> On 01/12/2012 11:31 AM, rmani@qca.qualcomm.com wrote:
>> From: Raja Mani<rmani@qca.qualcomm.com>
>>
>> ath6kl_read_fwlogs() assigns the value zero to the variable 'ret'
>> at the time of declaration. Later, return value of ath6kl_diag_read32()
>> repalces the init value. Hence removing useless zero assignment.
>>
>> Signed-off-by: Raja Mani<rmani@qca.qualcomm.com>
>
> Thanks, applied.
>
> BTW, I only got patch 1/2. What happened to patch 2?

Oops, I wanted to send only this patch.
It's a title mistake. Sorry about that.

>
> Kalle
