Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38592 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764747AbdEZLfr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 May 2017 07:35:47 -0400
Received: by mail-wm0-f53.google.com with SMTP id e127so18655579wmg.1
        for <linux-wireless@vger.kernel.org>; Fri, 26 May 2017 04:35:47 -0700 (PDT)
Subject: Re: [PATCH 4.12 REGRESSION fix] brcmfmac: Use ALIGNMENT rather then
 hardcoded "4" for bus:txglomalign
To: Hans de Goede <hdegoede@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <20170526110255.21342-1-hdegoede@redhat.com>
 <87d1avrhrg.fsf@kamboji.qca.qualcomm.com>
 <619191d3-8ed3-b2a5-e8db-330d7b610b2d@redhat.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <a3926467-4991-dba0-46e9-8397f25ff92d@broadcom.com> (sfid-20170526_133616_163070_CED8D962)
Date: Fri, 26 May 2017 13:35:36 +0200
MIME-Version: 1.0
In-Reply-To: <619191d3-8ed3-b2a5-e8db-330d7b610b2d@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26-05-17 13:18, Hans de Goede wrote:
> Hi,
> 
> On 26-05-17 13:15, Kalle Valo wrote:
>> Hans de Goede <hdegoede@redhat.com> writes:
>>
>>> From: Arend Van Spriel <arend.vanspriel@broadcom.com>
> 
> Ah I see I set the Author to Arend when I added this to my
> tree a while back, that is fine as he did all the work
> for this one. I was under the impression Arend would submit
> this himself, but since I did not see a submission yet
> I decided to go ahead and submit this.

I did not get to sending it last week. My work hours for open-source
have been reduced by 80% so time is limited. I have it queued.

>>> This fixes the following errors showing up in dmesg:
>>>
>>> [   32.528271] brcmfmac: brcmf_sdio_rxglom: sublen 524 not multiple of 8
>>> [   32.528296] brcmfmac: brcmf_sdio_rxglom: sublen 84 not multiple of 8
>>> [   33.063241] brcmfmac: brcmf_sdio_rxglom: sublen 1492 not multiple
>>> of 8
>>>
>>> Fixes: 6e84ab604bde ("properly align buffers ... with 64 bit DMA")
>>> Suggested-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>
>> I'll queue this to 4.12.
> 
> Thank you, given that Arend is set as the Author you can add my:
> 
> Tested-by: Hans de Goede <hdegoede@redhat.com>
> 
> And maybe drop the Suggested-by: Arend van Spriel ?

Seems to me you need my Signed-off-by: as I do not see that in this patch.

Regards,
Arend
