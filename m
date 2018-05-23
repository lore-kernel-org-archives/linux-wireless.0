Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42698 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754130AbeEWIRo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 04:17:44 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Ganapathi Bhat <gbhat@marvell.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: Re: [EXT] Re: [PATCH V2 3/6] mwifiex: support sysfs initiated device coredump
References: <1526472723-15758-1-git-send-email-arend.vanspriel@broadcom.com>
        <1526472723-15758-4-git-send-email-arend.vanspriel@broadcom.com>
        <87h8n7lnfx.fsf@kamboji.qca.qualcomm.com>
        <5AFC7E01.3070503@broadcom.com>
        <d9414fb243bf4a8daecfef11fe6cdc65@SC-EXCH02.marvell.com>
        <87po1mu7s2.fsf@purkki.adurom.net> <5B052248.5020805@broadcom.com>
Date: Wed, 23 May 2018 11:17:39 +0300
In-Reply-To: <5B052248.5020805@broadcom.com> (Arend van Spriel's message of
        "Wed, 23 May 2018 10:11:52 +0200")
Message-ID: <87d0xmeqfw.fsf@kamboji.qca.qualcomm.com> (sfid-20180523_101827_244900_68963445)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 5/23/2018 9:54 AM, Kalle Valo wrote:
>> Ganapathi Bhat <gbhat@marvell.com> writes:
>>
>>> In V2:
>>>
>>>          return ret;
>>>   }
>>> +EXPORT_SYMBOL_GPL(mwifiex_send_cmd);
>>>
>>> Instead of exporting 'mwifiex_send_cmd' we can prepare a wrapper for
>>> the command 'MWIFIEX_IFACE_WORK_DEVICE_DUMP' in mwifiex module. Let me
>>> know if we can send a follow up.
>>
>> So what's the plan? Can I apply this patch or should I drop it?
>
> Sorry. Had to reply that earlier. When adding the export I figured it
> might not be desirable. If Ganapathi can fix it with a follow up patch
> that would ok, right?

A follow up patch sounds good to me.

> Than you can apply it, I would say.

Good, thanks.

-- 
Kalle Valo
