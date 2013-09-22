Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f50.google.com ([209.85.212.50]:53213 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab3IVWrT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Sep 2013 18:47:19 -0400
Received: by mail-vb0-f50.google.com with SMTP id x14so1685473vbb.37
        for <linux-wireless@vger.kernel.org>; Sun, 22 Sep 2013 15:47:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFSJ42YUgJ-Bnx_DW_oJn6bk4BRVtyeD=b+G5oenefb3S7ZLNQ@mail.gmail.com>
References: <1378118306-7890-1-git-send-email-k.eugene.e@gmail.com>
	<5224A1F9.3030907@hauke-m.de>
	<CAFSJ42YUgJ-Bnx_DW_oJn6bk4BRVtyeD=b+G5oenefb3S7ZLNQ@mail.gmail.com>
Date: Sun, 22 Sep 2013 23:47:19 +0100
Message-ID: <CAFSJ42apLLXOdH-V3GQyDkBtQWZvQQNcbADXTNp48jGW9bSd3A@mail.gmail.com> (sfid-20130923_004726_822202_563C2C8A)
Subject: Re: [PATCH] wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

While waiting for the merge window to be opened a lot of changes were
added to wcn36xx. I sent wcn36xx for review again and as soon as it's
done will resend you the patch again. Hopefully review will go
smoothly so the plan is to resend a patch to you this week.

2013/9/2 Eugene Krasnikov <k.eugene.e@gmail.com>:
> Will check with legal department if licenses are compliant and come back to you.
> But I guess for driver contribution it's not mandatory.
>
> 2013/9/2 Hauke Mehrtens <hauke@hauke-m.de>:
>> On 09/02/2013 12:38 PM, Eugene Krasnikov wrote:
>>> This is a mac80211 driver for Qualcomm WCN3660/WCN3680 devices. So
>>> far WCN3660/WCN3680 is available only on MSM platform.
>>>
>>> Firmware can be found here:
>>> https://github.com/AOKP/vendor_sony/find/jb-mr1
>>
>> Will you send the firmware for inclusion to linux-fimware?
>> I am also missing the firmware for ath10k there.
>>
>>> Wiki page is available here:
>>> http://wireless.kernel.org/en/users/Drivers/wcn36xx
>>>
>>
>> Hauke
>>
>
>
>
> --
> Best regards,
> Eugene



-- 
Best regards,
Eugene
