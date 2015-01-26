Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:57150 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbbAZSue (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 13:50:34 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Message-ID: <54C68C69.6000902@qca.qualcomm.com> (sfid-20150126_195036_994745_D34162BF)
Date: Mon, 26 Jan 2015 20:50:17 +0200
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH 08/10] wil6210: Tx status
References: <1422175971-8075-1-git-send-email-qca_vkondrat@qca.qualcomm.com>	<1422175971-8075-9-git-send-email-qca_vkondrat@qca.qualcomm.com> <87oaplfyua.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87oaplfyua.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/2015 03:36 PM, Kalle Valo wrote:
> Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com> writes:
>
>> Implement Tx status reporting
>>
>> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
>
> I think the title is too short. I would like to change it to this, is
> that ok?
>
> wil6210: implement skb Tx status reporting
>
> Implment Tx status reporting using skb_complete_wifi_ack().
>

Yes, it is fine.

Thanks, Vladimir
