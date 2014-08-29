Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:28810 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbaH2Oh5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2014 10:37:57 -0400
Message-ID: <54009042.6070309@broadcom.com> (sfid-20140829_163800_570655_6846F742)
Date: Fri, 29 Aug 2014 16:37:54 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] ath10k: add testmode
References: <20140828072642.14691.44313.stgit@potku.adurom.net>	<20140828073041.14691.15099.stgit@potku.adurom.net>	<878um9ujn1.fsf@kamboji.qca.qualcomm.com>	<53FEFEDE.5030505@broadcom.com> <87y4u7suhu.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87y4u7suhu.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/29/14 08:03, Kalle Valo wrote:
> Arend van Spriel<arend@broadcom.com>  writes:
>
>> On 08/28/14 10:02, Kalle Valo wrote:
>>> Kalle Valo<kvalo@qca.qualcomm.com>   writes:
>>
>>> Johannes suggested to put this to a separate file as that way it's
>>> easier for the user space. In v3 I'm planning to create testmode_uapi.h
>>> for this.
>>
>> I suppose that file will/should end up in include/uapi/...
>
> I was thinking not to put this to the include directory. This is just a
> testmode interface used only by few people, not a proper driver
> interface.

I see. In that case I would avoid the term 'uapi'. I think it will 
impose certain expectations.

>> so wouldn't it be better to call it ath10k_testmode.h?
>
> We already have testmode.h so having ath10k_testmode.h in the same
> directory would be confusing. Would testmode_i.h be any better?

What does it contain? Looks like command and attribute definitions for 
your testmode support. Maybe testmode_defs.h? As long as it is not uapi.

Regards,
Arend
