Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:36121 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750771AbdEZRLh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 May 2017 13:11:37 -0400
Received: by mail-wm0-f49.google.com with SMTP id 7so61379wmo.1
        for <linux-wireless@vger.kernel.org>; Fri, 26 May 2017 10:11:37 -0700 (PDT)
Subject: Re: [PATCH 4.12 REGRESSION fix] brcmfmac: Use ALIGNMENT rather then
 hardcoded "4" for bus:txglomalign
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <20170526110255.21342-1-hdegoede@redhat.com>
 <87d1avrhrg.fsf@kamboji.qca.qualcomm.com>
 <619191d3-8ed3-b2a5-e8db-330d7b610b2d@redhat.com>
 <a3926467-4991-dba0-46e9-8397f25ff92d@broadcom.com>
 <874lw7r7nw.fsf@kamboji.qca.qualcomm.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <af46856e-e1b4-4fad-c4b3-2c462549f9ee@broadcom.com> (sfid-20170526_191141_512286_D1EF02EB)
Date: Fri, 26 May 2017 19:11:34 +0200
MIME-Version: 1.0
In-Reply-To: <874lw7r7nw.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26-05-17 16:53, Kalle Valo wrote:
> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
> 
>>>>> Fixes: 6e84ab604bde ("properly align buffers ... with 64 bit DMA")
>>>>> Suggested-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>>>
>>>> I'll queue this to 4.12.
>>>
>>> Thank you, given that Arend is set as the Author you can add my:
>>>
>>> Tested-by: Hans de Goede <hdegoede@redhat.com>
>>>
>>> And maybe drop the Suggested-by: Arend van Spriel ?
> 
> Sure, I can add that.
> 
>> Seems to me you need my Signed-off-by: as I do not see that in this patch.
> 
> Yes, that is needed if you are the author. If you reply to this message
> I can add that.

Ok. Here it is. Please feel free to add Signed-off-by tag for me
authoring this change. The Signed-off-by tag for Hans can stay as well
as this patch went through his hands (and he came up with the commit
message ;-) ).

Regards,
Arend
