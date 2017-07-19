Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:37406 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751911AbdGSLrO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jul 2017 07:47:14 -0400
Received: by mail-wm0-f47.google.com with SMTP id g127so13344371wmd.0
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jul 2017 04:47:14 -0700 (PDT)
Subject: Re: brcmfmac bus level addressing issues.
To: Ian Molton <ian@mnementh.co.uk>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Franky Lin <franky.lin@broadcom.com>,
        brcm80211-dev-list@broadcom.com,
        Hante Meuleman <hante.meuleman@broadcom.com>
References: <aacfa1fd-ac34-b3c1-b078-4b6a5eefe4ca@mnementh.co.uk>
 <87cdbbc12b504e89d2bd1c33df6a6bf6@mail.gmail.com>
 <5eb895bd-58cf-70fd-3c00-c8fed86aed79@mnementh.co.uk>
 <6fe08666ca09bf3c1d4476fdad8ce97a@mail.gmail.com>
 <222e2bc1-4d8f-8133-4fa7-51a48f3de785@mnementh.co.uk>
 <0395e3f6-6bd9-cbad-0fe2-9a5d32a9baa6@mnementh.co.uk>
 <701af0be-87b6-a397-ae29-a5ba75605588@broadcom.com>
 <feb0cba3-27da-6cab-316f-164867867cd6@mnementh.co.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <126c9c73-387e-e718-5ac8-e816ec922989@broadcom.com> (sfid-20170719_134719_231861_98AD3962)
Date: Wed, 19 Jul 2017 13:47:12 +0200
MIME-Version: 1.0
In-Reply-To: <feb0cba3-27da-6cab-316f-164867867cd6@mnementh.co.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19-07-17 00:45, Ian Molton wrote:

[...]

> Fair enough - I guess now that its in the kernel it needs fixing before
> 4.13 - but I would argue that no new features should go into the driver
> for the short term once that is done. Lets give it a good spring clean.
> 
> I am, actually, able to put some time into this, and *want* to help - MY
> current employer would benefit greatly from this driver becoming stable.
> 
> (as it stands, back to back wpasuplpicant runs make it keel over, as
> does module unload and reload).

It is good to get such feedback. We should get in details about this.

>> So I am chasing that although I am actually on vacation.
> 
> Dude - enjoy your vacation. Seriously.
> 

[...]

>> That really has to wait until I return as well as running some tests on
>> older 4329 and some newer chipsets.
> 
> Fair. When do you return? No pressure - it just means I know I can hold
> off and do something else on my project until then.

Vacation is only this week.

Regards,
Arend
