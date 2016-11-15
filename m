Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57106 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750772AbcKOLKX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 06:10:23 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Gianfranco Costamagna <locutusofborg@debian.org>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        "brcm80211-dev-list\@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "nsmaldone\@tierratelematics.com" <nsmaldone@tierratelematics.com>,
        "Marco.Arlone\@roj.com" <Marco.Arlone@roj.com>
Subject: Re: [PATCH] broadcom/brcm80211/brcmfmac/cfg80211 driver, bad regulatory domain frequency value
References: <CACJOhtL-oFTJC5j0_+fdecWExZBKvDy13o+UBzw47tyrvD_SJQ@mail.gmail.com>
        <CACJOhtKej4EZ3ufGGUr=Rf1X=hufmKtPLQH3y4x0kK4nNg5U0w@mail.gmail.com>
        <690669269.1124561.1477671348137@mail.yahoo.com>
        <5474e850-1c52-c896-da9e-45720ed6d6ff@broadcom.com>
        <0812c8f2-f0ce-c62c-5f09-fa46dafd630f@broadcom.com>
        <233918815.6357602.1479123253455@mail.yahoo.com>
        <fba3cf06-917f-f1c9-6735-f166a18aa222@broadcom.com>
        <810879191.6335567.1479124065921@mail.yahoo.com>
Date: Tue, 15 Nov 2016 13:10:17 +0200
In-Reply-To: <810879191.6335567.1479124065921@mail.yahoo.com> (Gianfranco
        Costamagna's message of "Mon, 14 Nov 2016 11:47:45 +0000 (UTC)")
Message-ID: <87r36dov6u.fsf@purkki.adurom.net> (sfid-20161115_121026_829056_F1DACD5D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gianfranco Costamagna <locutusofborg@debian.org> writes:

>> Well, not before you pointed it out ;-). You are welcome to send a patch
>> fixing it. Otherwise, I will take care of it.
>
> attaching a format-patch like version.
> I don't think we need a Tested-by or whatever, because it is just a typo in a comment.
> (this is my first contribution, feel free to rebase or change whatever you prefer
> to make it in line with other styles)
>
> (I gave authorship to Marco, the first one who discovered such typo)

[...]

> Signed-off-by: Gianfranco Costamagna <gianfranco.costamagna@abinsula.com>
> Signed-off-by: Nicola Smaldone <nicola.smaldone@tierraservice.com>
> Signed-off-by: Arlone Marco <marco.arlone@roj.com>

Please note that you cannot add Signed-off-by for other people without
their explicit approval (see Documentation/SubmittingPatches). I don't
know if they did it in this case or not, but wanted to point out this
anyway.

-- 
Kalle Valo
