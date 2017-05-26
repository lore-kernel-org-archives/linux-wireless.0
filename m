Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48972 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1035659AbdEZOyI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 May 2017 10:54:08 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH 4.12 REGRESSION fix] brcmfmac: Use ALIGNMENT rather then hardcoded "4" for bus:txglomalign
References: <20170526110255.21342-1-hdegoede@redhat.com>
        <87d1avrhrg.fsf@kamboji.qca.qualcomm.com>
        <619191d3-8ed3-b2a5-e8db-330d7b610b2d@redhat.com>
        <a3926467-4991-dba0-46e9-8397f25ff92d@broadcom.com>
Date: Fri, 26 May 2017 17:53:39 +0300
In-Reply-To: <a3926467-4991-dba0-46e9-8397f25ff92d@broadcom.com> (Arend van
        Spriel's message of "Fri, 26 May 2017 13:35:36 +0200")
Message-ID: <874lw7r7nw.fsf@kamboji.qca.qualcomm.com> (sfid-20170526_165442_800395_BFF768A5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

>>>> Fixes: 6e84ab604bde ("properly align buffers ... with 64 bit DMA")
>>>> Suggested-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>>
>>> I'll queue this to 4.12.
>> 
>> Thank you, given that Arend is set as the Author you can add my:
>> 
>> Tested-by: Hans de Goede <hdegoede@redhat.com>
>> 
>> And maybe drop the Suggested-by: Arend van Spriel ?

Sure, I can add that.

> Seems to me you need my Signed-off-by: as I do not see that in this patch.

Yes, that is needed if you are the author. If you reply to this message
I can add that.

-- 
Kalle Valo
