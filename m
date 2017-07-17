Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:33086 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751298AbdGQKiY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 06:38:24 -0400
Received: by mail-oi0-f48.google.com with SMTP id p188so114146117oia.0
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jul 2017 03:38:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <707b8832-a09e-9d8a-d4fc-6f9b73306680@mnementh.co.uk>
References: <20170716112129.10206-1-ian@mnementh.co.uk> <CACna6rxQNqdpuiq2mF3EJQ694AHa74tVex06vp53kqjrwoNkog@mail.gmail.com>
 <707b8832-a09e-9d8a-d4fc-6f9b73306680@mnementh.co.uk>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Mon, 17 Jul 2017 12:38:23 +0200
Message-ID: <CACna6rzdKyoUfS00GB-nJS_TNoa7znhnDaKQ8XFN979SZSOy1w@mail.gmail.com> (sfid-20170717_123835_034066_D22ECBDA)
Subject: Re: RFC: Broadcom fmac wireless driver cleanup
To: Ian Molton <ian@mnementh.co.uk>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gmail seems to mark your replies as spam :(

On 17 July 2017 at 11:34, Ian Molton <ian@mnementh.co.uk> wrote:
> On 17/07/17 05:53, Rafa=C5=82 Mi=C5=82ecki wrote:
>> I looked at 4 random patches and none got any description. Not to
>> mention their chaotic subjects. In this state I can't even review it.
>> If you want to have some change accepted, you've to convince us it's
>> needed. Work on cleaning your patches and resend them. You also need
>> to signed off your changes.
>
> This isn't my first rodeo. I know there are only outline descriptions,
> and no Sob.
>
> Thats because this is an RFC. You sign off *finished* work.

Sending signed patches, include RFCs is much more convenient. It
allows e.g. other people to pick your work if you won't manage to get
in accepted for some reason.


> This is a codebase I'm not 100% familiar with, and I don't know the
> maintainers - Im not going to polish patches if they aren't then going
> to get accepted upstream.
>
> I'm looking for comments on the actual *code*. Review requires *reading*
> it. Review is not just "I read the description and it looked ok at the
> time" - Thats clearly how this code got into this state in the first plac=
e.

I don't expect patches to be perfectly polished at RFC phase. I also
never said I'm interested in description only. Don't expect to get
nicely described hack to get accepted for that reason.

Description is supposed to provide a context for the changes. It's
easier to review *code changes* knowing what you are trying to
fix/achieve. It saves a lot of guessing time.


> Honestly, the patch robot has given more useful feedback than the humans
> on here thus far.
>
> But hey, if thats how patch submission works these days... I'll add some
> descriptions. But I'd better not be polishing this stuff for no reason.

Insulting maintainers may not be the best way of getting your stuff
reviewed & accepted.

--=20
Rafa=C5=82
