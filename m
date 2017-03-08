Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:36499 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751291AbdCHKP6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Mar 2017 05:15:58 -0500
Received: by mail-qk0-f174.google.com with SMTP id 1so56572136qkl.3
        for <linux-wireless@vger.kernel.org>; Wed, 08 Mar 2017 02:15:40 -0800 (PST)
Subject: Re: [PATCH v2 2/4] brcmfmac: p2p and normal ap access are not always
 possible at the same time
To: Hans de Goede <hdegoede@redhat.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170227214539.16422-1-hdegoede@redhat.com>
 <20170227214539.16422-2-hdegoede@redhat.com>
 <33689f32-1bf8-98f8-df65-278de097e435@broadcom.com>
 <738d049d-4e90-8a5d-e5c0-d037085a064c@redhat.com>
 <d0bec61e-4481-42b9-fcdd-d6a8f8f3524e@broadcom.com>
Cc: Takashi Iwai <tiwai@suse.de>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <edc0f67d-59d7-437c-2588-e895217577cd@broadcom.com> (sfid-20170308_111624_828204_E8DC8EB1)
Date: Wed, 8 Mar 2017 11:15:35 +0100
MIME-Version: 1.0
In-Reply-To: <d0bec61e-4481-42b9-fcdd-d6a8f8f3524e@broadcom.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8-3-2017 10:26, Arend Van Spriel wrote:
> On 8-3-2017 9:24, Hans de Goede wrote:
>> Hi,
>>
>> On 07-03-17 11:03, Arend Van Spriel wrote:
>>>
>>>
>>> On 27-2-2017 22:45, Hans de Goede wrote:
>>>> The firmware responding with -EBUSY when trying to add an extra
>>>> virtual-if
>>>> is a normal thing, do not print an error for this.
>>>
>>> This may be something we need to look into. It seems to me the interface
>>> combinations needs to be fixed so we do not try to provision firmware.
>>> Can you explain the scenario here?
>>
>> I'm not doing anything special just connecting to my isp provided
>> accesspoint
>> using NetworkManager.
> 
> Ok. So it is probably the P2P_DEVICE interface as that is the only
> interface being created in that scenario. Can you provide a log with
> brcmfmac driver debug=0x1416.

I guess you are seeing this with 43362. Is that correct?

Regards,
Arend
