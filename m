Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:39883 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754356AbeEWILz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 04:11:55 -0400
Received: by mail-qt0-f180.google.com with SMTP id f1-v6so26959314qtj.6
        for <linux-wireless@vger.kernel.org>; Wed, 23 May 2018 01:11:55 -0700 (PDT)
Subject: Re: [EXT] Re: [PATCH V2 3/6] mwifiex: support sysfs initiated device
 coredump
To: Kalle Valo <kvalo@codeaurora.org>,
        Ganapathi Bhat <gbhat@marvell.com>
References: <1526472723-15758-1-git-send-email-arend.vanspriel@broadcom.com>
 <1526472723-15758-4-git-send-email-arend.vanspriel@broadcom.com>
 <87h8n7lnfx.fsf@kamboji.qca.qualcomm.com> <5AFC7E01.3070503@broadcom.com>
 <d9414fb243bf4a8daecfef11fe6cdc65@SC-EXCH02.marvell.com>
 <87po1mu7s2.fsf@purkki.adurom.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B052248.5020805@broadcom.com> (sfid-20180523_101559_595815_AFADBA3B)
Date: Wed, 23 May 2018 10:11:52 +0200
MIME-Version: 1.0
In-Reply-To: <87po1mu7s2.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/23/2018 9:54 AM, Kalle Valo wrote:
> Ganapathi Bhat <gbhat@marvell.com> writes:
>
>> In V2:
>>
>>          return ret;
>>   }
>> +EXPORT_SYMBOL_GPL(mwifiex_send_cmd);
>>
>> Instead of exporting 'mwifiex_send_cmd' we can prepare a wrapper for
>> the command 'MWIFIEX_IFACE_WORK_DEVICE_DUMP' in mwifiex module. Let me
>> know if we can send a follow up.
>
> So what's the plan? Can I apply this patch or should I drop it?

Sorry. Had to reply that earlier. When adding the export I figured it 
might not be desirable. If Ganapathi can fix it with a follow up patch 
that would ok, right? Than you can apply it, I would say.

Regards,
Arend
