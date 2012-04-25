Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57572 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab2DYGlC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 02:41:02 -0400
Message-ID: <4F979C73.90102@qca.qualcomm.com> (sfid-20120425_084108_026903_794EB194)
Date: Wed, 25 Apr 2012 12:10:51 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Don't advertise HT capability for incapable firmware
References: <1335171233-23814-1-git-send-email-vthiagar@qca.qualcomm.com> <4F97993F.3080606@qca.qualcomm.com>
In-Reply-To: <4F97993F.3080606@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Wednesday 25 April 2012 11:57 AM, Kalle Valo wrote:
> On 04/23/2012 11:53 AM, Vasanthakumar Thiagarajan wrote:
>> With firmwares which do not support rsn capability override
>> (ATH6KL_FW_CAPABILITY_RSN_CAP_OVERRIDE) from host would
>> cause 4-way handshake failure when HT cap is advertised.
>> To fix this, do not advertise HT cap with cfg80211 for
>> those fw.
>>
>> Signed-off-by: Vasanthakumar Thiagarajan<vthiagar@qca.qualcomm.com>
>
> This conflicts which Thomas' changes in the same area. Care to rebase
> your patches? I think the patch will become pretty simple after the
> rebase but I didn't dare to do it myself :)

Not an issue, i'll do that, thanks!.

Vasanth
