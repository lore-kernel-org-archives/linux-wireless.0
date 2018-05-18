Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:34614 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752327AbeERJAm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 05:00:42 -0400
Received: by mail-qt0-f194.google.com with SMTP id m5-v6so9357788qti.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 May 2018 02:00:42 -0700 (PDT)
Subject: Re: [PATCH V3 0/5] Update brcm firmware files
To: Hans de Goede <hdegoede@redhat.com>,
        Josh Boyer <jwboyer@kernel.org>
References: <1521209329-59441-1-git-send-email-chi-hsien.lin@cypress.com>
 <5AF960B6.2010709@broadcom.com>
 <CA+5PVA7m3wWHyi12rTcpAozj=en9BtnsVAKAbQyvKvPRh_jC4A@mail.gmail.com>
 <5AFA9DB0.7060703@broadcom.com>
 <e2b71216-dc95-6d16-47c3-6b50da03a716@redhat.com>
Cc: Linux Firmware <linux-firmware@kernel.org>,
        chi-hsien.lin@cypress.com,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, wright.feng@cypress.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AFE9637.8010607@broadcom.com> (sfid-20180518_110225_620414_103521C2)
Date: Fri, 18 May 2018 11:00:39 +0200
MIME-Version: 1.0
In-Reply-To: <e2b71216-dc95-6d16-47c3-6b50da03a716@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/18/2018 9:04 AM, Hans de Goede wrote:
> Hi,
>
> On 15-05-18 10:43, Arend van Spriel wrote:
>> On 5/14/2018 2:05 PM, Josh Boyer wrote:
>>> n Mon, May 14, 2018 at 6:11 AM Arend van Spriel <
>>> arend.vanspriel@broadcom.com> wrote:
>>>
>>>> On 3/16/2018 3:08 PM, Chi-Hsien Lin wrote:
>>>>> Update brcm firmware files and WHENCE accordingly.
>>>
>>>> Hi firmware-maintainers,
>>>
>>>> It seems this series somehow got lost. Can these still be applied. They
>>>> can be found in the linux-wireless patchwork database. I provided links
>>>> below.
>>>
>>> All 5 of these move the respective firmware files under the Cypress
>>> license.  It has been pointed out that the Cypress license has some
>>> questionable language in it and that people have been in touch to try
>>> and
>>> get this resolved.  I'm personally waiting on applying them until the
>>> licence issue is sorted out.
>>
>> Thanks, Josh
>>
>> I could not find any such response. Has it been taken off-list? Seems
>> like 2 months is quite some time, but maybe there are lawyers involved
>> ;-)
>
> Yes the discussion about this has been happening off-list. IANAL but
> the gist of it is (AFAIK) that:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/LICENCE.cypress
>
>
> has a clause which allows Cypress to retro-actively revoke the LICENSE:
>
> "either party may terminate this Agreement at any time with or without
> cause."
> ...
> "Upon termination, you must destroy all copies of Software in your
> possession or
> control."
>
> So upon revokation we would have to remove the files from linux-firmware
> (rewrite git history?) and since distros get their redistribution rights
> from this license too they would also need to remove it from their packages
> including all mirrors and archives of older versions. Which simply is not
> feasible and no other license in linux-firmware has such a clause.

Check again. From LICENCE.broadcom_bcm43xx:

"""
2.      Restrictions. Licensee shall distribute Software with a copy of this
Agreement. Licensee shall not remove, efface or obscure any copyright or
trademark notices from the Software. Reproductions of the Broadcom copyright
notice shall be included with each copy of the Software, except where such
Software is embedded in a manner not readily accessible to the end user.
Licensee shall not: (i) use, license, sell or otherwise distribute the 
Software
except as provided in this Agreement; (ii) attempt to modify in any way,
reverse engineer, decompile or disassemble any portion of the Software; or
(iii) use the Software or other material in violation of any applicable 
law or
regulation, including but not limited to any regulatory agency. This 
Agreement
shall automatically terminate upon Licensee\u2019s failure to comply 
with any of the
terms of this Agreement. In such event, Licensee will destroy all copies 
of the
Software and its component parts.
"""

Regards,
Arend
