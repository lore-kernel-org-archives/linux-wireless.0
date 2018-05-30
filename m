Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:39646 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934903AbeE3HsP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 03:48:15 -0400
Received: by mail-wm0-f66.google.com with SMTP id f8-v6so45912069wmc.4
        for <linux-wireless@vger.kernel.org>; Wed, 30 May 2018 00:48:15 -0700 (PDT)
Subject: Re: [PATCH V3 0/5] Update brcm firmware files
To: chi-hsien.lin@cypress.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Josh Boyer <jwboyer@kernel.org>
Cc: Linux Firmware <linux-firmware@kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, wright.feng@cypress.com
References: <1521209329-59441-1-git-send-email-chi-hsien.lin@cypress.com>
 <5AF960B6.2010709@broadcom.com>
 <CA+5PVA7m3wWHyi12rTcpAozj=en9BtnsVAKAbQyvKvPRh_jC4A@mail.gmail.com>
 <5AFA9DB0.7060703@broadcom.com>
 <e2b71216-dc95-6d16-47c3-6b50da03a716@redhat.com>
 <1aeb2068-1630-b554-2117-3aa68bdf0eea@redhat.com>
 <8688d1c7-8222-d51f-4bc7-400786b27526@cypress.com>
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <227c89d2-4bc3-367d-26e9-bcc696cdd1a7@redhat.com> (sfid-20180530_094956_419298_1C560B12)
Date: Wed, 30 May 2018 09:48:13 +0200
MIME-Version: 1.0
In-Reply-To: <8688d1c7-8222-d51f-4bc7-400786b27526@cypress.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 30-05-18 09:28, Chi-Hsien Lin wrote:
> 
> 
> On 05/27/2018 10:37, Hans de Goede wrote:
>> Hi,
>>
>> On 18-05-18 09:04, Hans de Goede wrote:
>>> Hi,
>>>
>>> On 15-05-18 10:43, Arend van Spriel wrote:
>>>> On 5/14/2018 2:05 PM, Josh Boyer wrote:
>>>>> n Mon, May 14, 2018 at 6:11 AM Arend van Spriel <
>>>>> arend.vanspriel@broadcom.com> wrote:
>>>>>
>>>>>> On 3/16/2018 3:08 PM, Chi-Hsien Lin wrote:
>>>>>>> Update brcm firmware files and WHENCE accordingly.
>>>>>
>>>>>> Hi firmware-maintainers,
>>>>>
>>>>>> It seems this series somehow got lost. Can these still be applied. They
>>>>>> can be found in the linux-wireless patchwork database. I provided links
>>>>>> below.
>>>>>
>>>>> All 5 of these move the respective firmware files under the Cypress
>>>>> license.  It has been pointed out that the Cypress license has some
>>>>> questionable language in it and that people have been in touch to try and
>>>>> get this resolved.  I'm personally waiting on applying them until the
>>>>> licence issue is sorted out.
>>>>
>>>> Thanks, Josh
>>>>
>>>> I could not find any such response. Has it been taken off-list? Seems like 2 months is quite some time, but maybe there are lawyers involved ;-)
>>>
>>> Yes the discussion about this has been happening off-list. IANAL but
>>> the gist of it is (AFAIK) that:
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/LICENCE.cypress
>>>
>>> has a clause which allows Cypress to retro-actively revoke the LICENSE:
>>>
>>> "either party may terminate this Agreement at any time with or without cause."
>>> ...
>>> "Upon termination, you must destroy all copies of Software in your possession or
>>> control."
>>>
>>> So upon revokation we would have to remove the files from linux-firmware
>>> (rewrite git history?) and since distros get their redistribution rights
>>> from this license too they would also need to remove it from their packages
>>> including all mirrors and archives of older versions. Which simply is not
>>> feasible and no other license in linux-firmware has such a clause.
>>
>> Chi-Hsien or other people from Cypress, any progress on getting the license
>> updated to remove the troublesome termination without cause clause?
> Hi all,
> 
> I have received the updated license from the Legal department today. Have just submitted a V4 with the updated license.

Great, thank you (note I've not checked the new license yet).

Regards,

Hans
