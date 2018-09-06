Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:48553 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728633AbeIFRnM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 13:43:12 -0400
Received: from mail-yw1-f69.google.com ([209.85.161.69])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1fxu0f-0001aQ-T7
        for linux-wireless@vger.kernel.org; Thu, 06 Sep 2018 13:07:45 +0000
Received: by mail-yw1-f69.google.com with SMTP id l2-v6so6984528ywb.6
        for <linux-wireless@vger.kernel.org>; Thu, 06 Sep 2018 06:07:45 -0700 (PDT)
Date: Thu, 6 Sep 2018 08:07:42 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Jukka Pirinen <jukka.pirinen@gmail.com>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: wireless-regdb: Update regulatory rules for Finland (FI) on 5GHz
 (SRD devices)
Message-ID: <20180906130742.GF4251@ubuntu-xps13> (sfid-20180906_150749_983693_4B1EA906)
References: <CADyz9cHb+T3dTfQGShs3oHiZagQDdJP8LRKwmWPzp1fD_EPxag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CADyz9cHb+T3dTfQGShs3oHiZagQDdJP8LRKwmWPzp1fD_EPxag@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 28, 2018 at 01:32:25PM +0300, Jukka Pirinen wrote:
> Viestintävirasto 15 AM/2018 M
> 
> Section 10 Non-specific short range devices
> https://www.finlex.fi/data/normit/32670/Regulation_15AM.pdf

Thanks for the patch. It looks like it should be fine to add that range,
but there are a couple of problems. First, your patch has tabs replaced
with spaces and so it does not apply. Second, you must include a
Signed-off-by tag as specified in the CONTRIBUTING file.

Thanks,
Seth

> 
> 
> diff --git a/db.txt b/db.txt
> index 8cf7dee..7abb064 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -460,6 +460,8 @@ country FI: DFS-ETSI
>         (5150 - 5250 @ 80), (23), NO-OUTDOOR, AUTO-BW, wmmrule=ETSI
>         (5250 - 5350 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW, wmmrule=ETSI
>         (5470 - 5725 @ 160), (27), DFS, wmmrule=ETSI
> +        # short range devices (ETSI EN 300 440-1)
> +        (5725 - 5875 @ 80), (25 mW)
>         # 60 GHz band channels 1-4, ref: Etsi En 302 567
>         (57000 - 66000 @ 2160), (40)
