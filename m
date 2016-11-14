Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:34735 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752344AbcKNLgz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 06:36:55 -0500
Received: by mail-pf0-f177.google.com with SMTP id c4so17557845pfb.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Nov 2016 03:36:54 -0800 (PST)
Subject: Re: [PATCH] broadcom/brcm80211/brcmfmac/cfg80211 driver, bad
 regulatory domain frequency value
To: Gianfranco Costamagna <locutusofborg@debian.org>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <CACJOhtL-oFTJC5j0_+fdecWExZBKvDy13o+UBzw47tyrvD_SJQ@mail.gmail.com>
 <CACJOhtKej4EZ3ufGGUr=Rf1X=hufmKtPLQH3y4x0kK4nNg5U0w@mail.gmail.com>
 <690669269.1124561.1477671348137@mail.yahoo.com>
 <5474e850-1c52-c896-da9e-45720ed6d6ff@broadcom.com>
 <0812c8f2-f0ce-c62c-5f09-fa46dafd630f@broadcom.com>
 <233918815.6357602.1479123253455@mail.yahoo.com>
Cc: "nsmaldone@tierratelematics.com" <nsmaldone@tierratelematics.com>,
        "Marco.Arlone@roj.com" <Marco.Arlone@roj.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <fba3cf06-917f-f1c9-6735-f166a18aa222@broadcom.com> (sfid-20161114_123738_360333_F3885D50)
Date: Mon, 14 Nov 2016 12:36:50 +0100
MIME-Version: 1.0
In-Reply-To: <233918815.6357602.1479123253455@mail.yahoo.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14-11-2016 12:34, Gianfranco Costamagna wrote:
> Hi Arend,
> 
> 
>> Finally response. As it turns out the range was explcitly changed
> 
>> enabling channels 12 and 13 to be used where applicable. They forgot to
>> update the comment.
> 
> 
> so, the struct in net/wireless/reg.c is actually used in that case?
> 
> static const struct ieee80211_regdomain world_regdom = {
> 
> do you plan to update the comment?

Well, not before you pointed it out ;-). You are welcome to send a patch
fixing it. Otherwise, I will take care of it.

Regards,
Arend
