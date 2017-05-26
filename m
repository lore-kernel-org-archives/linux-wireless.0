Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43108 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S967435AbdEZLSz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 May 2017 07:18:55 -0400
Subject: Re: [PATCH 4.12 REGRESSION fix] brcmfmac: Use ALIGNMENT rather then
 hardcoded "4" for bus:txglomalign
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <20170526110255.21342-1-hdegoede@redhat.com>
 <87d1avrhrg.fsf@kamboji.qca.qualcomm.com>
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <619191d3-8ed3-b2a5-e8db-330d7b610b2d@redhat.com> (sfid-20170526_132058_674663_75B9179E)
Date: Fri, 26 May 2017 13:18:52 +0200
MIME-Version: 1.0
In-Reply-To: <87d1avrhrg.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 26-05-17 13:15, Kalle Valo wrote:
> Hans de Goede <hdegoede@redhat.com> writes:
> 
>> From: Arend Van Spriel <arend.vanspriel@broadcom.com>

Ah I see I set the Author to Arend when I added this to my
tree a while back, that is fine as he did all the work
for this one. I was under the impression Arend would submit
this himself, but since I did not see a submission yet
I decided to go ahead and submit this.

>> This fixes the following errors showing up in dmesg:
>>
>> [   32.528271] brcmfmac: brcmf_sdio_rxglom: sublen 524 not multiple of 8
>> [   32.528296] brcmfmac: brcmf_sdio_rxglom: sublen 84 not multiple of 8
>> [   33.063241] brcmfmac: brcmf_sdio_rxglom: sublen 1492 not multiple of 8
>>
>> Fixes: 6e84ab604bde ("properly align buffers ... with 64 bit DMA")
>> Suggested-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> 
> I'll queue this to 4.12.

Thank you, given that Arend is set as the Author you can add my:

Tested-by: Hans de Goede <hdegoede@redhat.com>

And maybe drop the Suggested-by: Arend van Spriel ?

Regards,

Hans
