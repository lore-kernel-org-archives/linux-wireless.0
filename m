Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:54305 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755217AbeDCLQe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 07:16:34 -0400
Received: by mail-wm0-f65.google.com with SMTP id r191so2203271wmg.4
        for <linux-wireless@vger.kernel.org>; Tue, 03 Apr 2018 04:16:34 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: fix firmware request processing if nvram load
 fails
To: Kalle Valo <kvalo@codeaurora.org>
References: <1522743495-13004-1-git-send-email-arend.vanspriel@broadcom.com>
 <87o9j0ip11.fsf@kamboji.qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AC3628F.7080900@broadcom.com> (sfid-20180403_131638_305821_056FB68E)
Date: Tue, 3 Apr 2018 13:16:31 +0200
MIME-Version: 1.0
In-Reply-To: <87o9j0ip11.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/3/2018 12:04 PM, Kalle Valo wrote:
> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
>
>> When nvram loading fails a double free occurred. Fix this and reorg the
>> code a little.
>>
>> Fixes: commit d09ae51a4b67 ("brcmfmac: pass struct in brcmf_fw_get_firmwares()")
>
> This should be:
>
> Fixes: d09ae51a4b67 ("brcmfmac: pass struct in brcmf_fw_get_firmwares()")
>
> I can fix that during commit.
>
>> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> ---
>> Hi Kalle,
>>
>> This fix is for code currently(?) in linux-next in error path caused
>> a double free.
>
> Ok, I'll queue this to wireless-drivers (after I have fast forwarded it)
> for 4.17.

Thanks

Arend
