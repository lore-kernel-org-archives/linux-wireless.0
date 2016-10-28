Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:36113 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756750AbcJ1UlI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Oct 2016 16:41:08 -0400
Received: by mail-wm0-f52.google.com with SMTP id p190so35482410wmp.1
        for <linux-wireless@vger.kernel.org>; Fri, 28 Oct 2016 13:41:07 -0700 (PDT)
Subject: Re: [PATCH] broadcom/brcm80211/brcmfmac/cfg80211 driver, bad
 regulatory domain frequency value
To: Gianfranco Costamagna <locutusofborg@debian.org>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <CACJOhtL-oFTJC5j0_+fdecWExZBKvDy13o+UBzw47tyrvD_SJQ@mail.gmail.com>
 <CACJOhtKej4EZ3ufGGUr=Rf1X=hufmKtPLQH3y4x0kK4nNg5U0w@mail.gmail.com>
 <690669269.1124561.1477671348137@mail.yahoo.com>
Cc: "nsmaldone@tierratelematics.com" <nsmaldone@tierratelematics.com>,
        "Marco.Arlone@roj.com" <Marco.Arlone@roj.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5474e850-1c52-c896-da9e-45720ed6d6ff@broadcom.com> (sfid-20161028_224111_843965_A3E6640B)
Date: Fri, 28 Oct 2016 22:41:06 +0200
MIME-Version: 1.0
In-Reply-To: <690669269.1124561.1477671348137@mail.yahoo.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28-10-2016 18:15, Gianfranco Costamagna wrote:
> (resending from my debian.org mail address, to avoid spam filtering)
> 
> Hi Broadcom developers and linux wireless list.
> 
> We found a possible issue in the cfg80211 implementation of the regulatory domain rules:
> 
>         .reg_rules = {
>                 /* IEEE 802.11b/g, channels 1..11 */
>                 REG_RULE(2412-10, 2472+10, 40, 6, 20, 0),
> 
> 
> the referred channel 11 has/should have a frequency of 2462, not 2472 (corresponding to channel 13).
> Is this a typo in the code or the above comment?
> 
> (I'm not sure why the override of reg.c is in place for 2.4 Ghz frequencies)
> 
> Can you please double check and in case apply the attached patch?

checking.... stay tuned.

Regards,
Arend
