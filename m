Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:34866 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750861AbeAPUV2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 15:21:28 -0500
Received: by mail-wm0-f53.google.com with SMTP id r78so11234331wme.0
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jan 2018 12:21:27 -0800 (PST)
Subject: Re: AP6335 with mainline kernel
To: Fabio Estevam <festevam@gmail.com>,
        Vanessa Maegima <vanessa.maegima@nxp.com>
References: <CABACg+yVE+fuzT-qwjNnACqq24KQbNJOae22=v+J+0Q=8kuKRQ@mail.gmail.com>
 <85717463-11e2-e2e3-b08e-b758986687b5@broadcom.com>
 <1510916848.26896.2.camel@nxp.com> <5A0EDC25.7030505@broadcom.com>
 <1510932224.22506.0.camel@nxp.com>
 <d9a80a75-b3d4-d78e-a5bf-ab31732f040d@broadcom.com>
 <e14bdc26-5092-18c9-4caa-c45fd1d12984@broadcom.com>
 <1511347672.18886.2.camel@nxp.com> <5A15584A.9090601@broadcom.com>
 <1511450638.9102.1.camel@nxp.com> <5A1FFA17.6000703@broadcom.com>
 <1512413992.18900.3.camel@nxp.com>
 <CAF7Mx6q6mTOXc=4OFVCHAHd26pyfv5e6pK=TMNmb1S6=FBWUWQ@mail.gmail.com>
 <1512485878.9392.1.camel@nxp.com>
 <CAOMZO5DXoCFgTtuRRAq_jFjzkzFp6chMCwczXF5Z0bFaNfQnog@mail.gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "van.ayumi@gmail.com" <van.ayumi@gmail.com>,
        "embed3d@gmail.com" <embed3d@gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A5E5EBE.7040301@broadcom.com> (sfid-20180116_212131_956260_09073543)
Date: Tue, 16 Jan 2018 21:21:18 +0100
MIME-Version: 1.0
In-Reply-To: <CAOMZO5DXoCFgTtuRRAq_jFjzkzFp6chMCwczXF5Z0bFaNfQnog@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/15/2018 9:08 PM, Fabio Estevam wrote:
> Hi Arend,
>
> On Tue, Dec 5, 2017 at 12:58 PM, Vanessa Maegima
> <vanessa.maegima@nxp.com> wrote:
>
>> Hi Arend,
>>
>> Sorry for this!
>>
>> I updated the folder on https://drive.google.com/drive/folders/1fosahjL
>> N1KI5NKS59_aPZdHLpENPFHtK
>>
>> Thanks!
>
> Any ideas, please?

Well, the dumps confirm a crash early in the firmware boot. However, I 
could not obtain more information from it. To capture the failure I need 
to rework some firmware functionality which is not trivial and I can not 
claim time for it right now.

Regards,
Arend
