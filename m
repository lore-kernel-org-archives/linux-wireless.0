Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f181.google.com ([209.85.160.181]:32867 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbcBOKDE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2016 05:03:04 -0500
Received: by mail-yk0-f181.google.com with SMTP id z13so58202437ykd.0
        for <linux-wireless@vger.kernel.org>; Mon, 15 Feb 2016 02:03:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAF7Mx6oiw+AdAqZU5rkZT4UeGTiTHR-DfsMN6dpsV6YFWkUOOg@mail.gmail.com>
References: <1455487069-2721-1-git-send-email-festevam@gmail.com>
	<CAF7Mx6oiw+AdAqZU5rkZT4UeGTiTHR-DfsMN6dpsV6YFWkUOOg@mail.gmail.com>
Date: Mon, 15 Feb 2016 11:03:03 +0100
Message-ID: <CAF7Mx6oFonTs-idWrprEk9pHZ98TOwX9tE=rLgSJ8cmjm1Aizg@mail.gmail.com> (sfid-20160215_110312_800001_4517F5C7)
Subject: Re: [PATCH] brcmfmac: of: Include "of.h" header file
From: Arend Van Spriel <arend.van@broadcom.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: kvalo@codeaurora.org, Arend Van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org,
	Fabio Estevam <fabio.estevam@nxp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am actually preparing a patch series and found that this change is
incorporated in that series. As that involves other changes it is
probably better to drop this patch. I thought I could change the
patchwork state for it, but no luck.

Regards,
Arend

On Mon, Feb 15, 2016 at 10:15 AM, Arend Van Spriel
<arend.van@broadcom.com> wrote:
> On Sun, Feb 14, 2016 at 10:57 PM, Fabio Estevam <festevam@gmail.com> wrote:
>> From: Fabio Estevam <fabio.estevam@nxp.com>
>>
>> Include "of.h" header file to fix the following sparse warning:
>>
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c:27:6: warning: symbol 'brcmf_of_probe' was not declared. Should it be static?
>
> Acked-by: Arend van Spriel <arend@broadcom.com>
>> Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
>> ---
>> Resending to linux-wireless@vger.kernel.org
>>
>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
>> index 03f35e0..6231b36 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
>> @@ -23,6 +23,7 @@
>>  #include <defs.h>
>>  #include "debug.h"
>>  #include "sdio.h"
>> +#include "of.h"
>>
>>  void brcmf_of_probe(struct brcmf_sdio_dev *sdiodev)
>>  {
>> --
>> 1.9.1
>>
