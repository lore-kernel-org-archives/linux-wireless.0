Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:34663 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751850AbdBMRrV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Feb 2017 12:47:21 -0500
Received: by mail-yb0-f195.google.com with SMTP id w194so4332148ybe.1
        for <linux-wireless@vger.kernel.org>; Mon, 13 Feb 2017 09:47:21 -0800 (PST)
From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] rtl8xxxu: Add (0x2357 0x0107) to the tested devices list.
To: Kalle Valo <kvalo@codeaurora.org>,
        Aaryn Coutanche <aaryncoutanche@gmail.com>
References: <1486814067-9874-1-git-send-email-aaryncoutanche@gmail.com>
 <87o9y6bg9y.fsf@purkki.adurom.net>
Cc: linux-wireless@vger.kernel.org
Message-ID: <9c57441d-4c97-febc-d2bc-fe1dc1b06b1b@gmail.com> (sfid-20170213_184725_348299_674F7AC4)
Date: Mon, 13 Feb 2017 12:47:18 -0500
MIME-Version: 1.0
In-Reply-To: <87o9y6bg9y.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/13/2017 04:18 AM, Kalle Valo wrote:
> Aaryn Coutanche <aaryncoutanche@gmail.com> writes:
>
>> From: Aaryn Coutanche <aaryncoutanche@gmail.com>
>>
>> ---
>>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 3 +++
>>  1 file changed, 3 insertions(+)
>
> Signed-off-by is missing, please read Documentation/SubmittingPatches.
> Also write a short commit log and document the device you used to test
> this etc.
>

Aaryn,

I already mentioned the Signed-off-by part to you - please make sure to 
always include that.

In general a commit message should have a headline and then a body 
message with a little more detail.

Cheers,
Jes
