Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:35690 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752790AbcKPKiJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2016 05:38:09 -0500
Received: by mail-pf0-f178.google.com with SMTP id i88so42300957pfk.2
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2016 02:38:09 -0800 (PST)
Subject: Re: [PATCH] broadcom/brcm80211/brcmfmac/cfg80211 driver, bad
 regulatory domain frequency value
To: Kalle Valo <kvalo@codeaurora.org>,
        Gianfranco Costamagna <locutusofborg@debian.org>
References: <CACJOhtL-oFTJC5j0_+fdecWExZBKvDy13o+UBzw47tyrvD_SJQ@mail.gmail.com>
 <CACJOhtKej4EZ3ufGGUr=Rf1X=hufmKtPLQH3y4x0kK4nNg5U0w@mail.gmail.com>
 <690669269.1124561.1477671348137@mail.yahoo.com>
 <5474e850-1c52-c896-da9e-45720ed6d6ff@broadcom.com>
 <0812c8f2-f0ce-c62c-5f09-fa46dafd630f@broadcom.com>
 <233918815.6357602.1479123253455@mail.yahoo.com>
 <fba3cf06-917f-f1c9-6735-f166a18aa222@broadcom.com>
 <810879191.6335567.1479124065921@mail.yahoo.com>
 <87r36dov6u.fsf@purkki.adurom.net>
Cc: "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "nsmaldone@tierratelematics.com" <nsmaldone@tierratelematics.com>,
        "Marco.Arlone@roj.com" <Marco.Arlone@roj.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <f00a3e1d-acf5-fc6a-e3b6-ab687a359dd2@broadcom.com> (sfid-20161116_113813_600601_DB88423F)
Date: Wed, 16 Nov 2016 11:38:03 +0100
MIME-Version: 1.0
In-Reply-To: <87r36dov6u.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15-11-2016 12:10, Kalle Valo wrote:
> Gianfranco Costamagna <locutusofborg@debian.org> writes:
> 
>>> Well, not before you pointed it out ;-). You are welcome to send a patch
>>> fixing it. Otherwise, I will take care of it.
>>
>> attaching a format-patch like version.
>> I don't think we need a Tested-by or whatever, because it is just a typo in a comment.
>> (this is my first contribution, feel free to rebase or change whatever you prefer
>> to make it in line with other styles)
>>
>> (I gave authorship to Marco, the first one who discovered such typo)
> 
> [...]
> 
>> Signed-off-by: Gianfranco Costamagna <gianfranco.costamagna@abinsula.com>
>> Signed-off-by: Nicola Smaldone <nicola.smaldone@tierraservice.com>
>> Signed-off-by: Arlone Marco <marco.arlone@roj.com>
> 
> Please note that you cannot add Signed-off-by for other people without
> their explicit approval (see Documentation/SubmittingPatches). I don't
> know if they did it in this case or not, but wanted to point out this
> anyway.

Thanks, Kalle

It was on my list to give a contrib boot camp here. So let's go over
things here albeit it late.

Hi Gianfrance,

A couple of things from which you may benefit for future contributions.
Basic info can be found in Documentation/SubmittingPatches as Kalle
indicated.

Patches should not be submitted as attachments. After doing 'git
format-patch' the easiest way is using 'git send-email' (which requires
you to have sendmail on your system properly setup). I tend to send
patches to Kalle and Cc: linux-wireless, but that is my personal
preference. Sending it to the list should be sufficient as patchwork
will pick it up [1].

When it comes to attribution of others you should have their approval
for Signed-off-by. However, reading your remarks it seems a proper way
is below:

Reported-by: Arlone Marco <marco.arlone@roj.com>
Tested-by: Nicola Smaldone <nicola.smaldone@tierraservice.com>
Signed-off-by: Gianfranco Costamagna <gianfranco.costamagna@abinsula.com>

Regards,
Arend

[1] https://patchwork.kernel.org/project/linux-wireless/list/
