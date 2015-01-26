Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52542 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbbAZSvz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 13:51:55 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Message-ID: <54C68CAB.4050407@qca.qualcomm.com> (sfid-20150126_195158_538869_809E8B1C)
Date: Mon, 26 Jan 2015 20:51:23 +0200
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH 09/10] wil6210: probe_client
References: <1422175971-8075-1-git-send-email-qca_vkondrat@qca.qualcomm.com>	<1422175971-8075-10-git-send-email-qca_vkondrat@qca.qualcomm.com> <87k309fyrf.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87k309fyrf.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/2015 03:38 PM, Kalle Valo wrote:
> Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com> writes:
>
>> Access point require this API to check peer alive status.
>> Assume peer is alive when it is connected, because
>> firmware implements keep alive checks and will disconnect
>> peer if it is not alive.
>>
>> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
>
> Here the title is again too short, is it ok if I change it to this:
>
> wil6210: implement cfg80211 probe_client() op
>
Yes, this is OK.

Thanks, Vladimir
