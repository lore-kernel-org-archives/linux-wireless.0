Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:36540 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751249AbdGQExy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 00:53:54 -0400
Received: by mail-oi0-f51.google.com with SMTP id x187so109039046oig.3
        for <linux-wireless@vger.kernel.org>; Sun, 16 Jul 2017 21:53:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170716112129.10206-1-ian@mnementh.co.uk>
References: <20170716112129.10206-1-ian@mnementh.co.uk>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Mon, 17 Jul 2017 06:53:53 +0200
Message-ID: <CACna6rxQNqdpuiq2mF3EJQ694AHa74tVex06vp53kqjrwoNkog@mail.gmail.com> (sfid-20170717_065358_678380_4453C1F4)
Subject: Re: RFC: Broadcom fmac wireless driver cleanup
To: Ian Molton <ian@mnementh.co.uk>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 July 2017 at 13:21, Ian Molton <ian@mnementh.co.uk> wrote:
> I've been doing some cleanups in the broadcome brcmfmac driver, trying to
> understand how it works.
>
> I think this makes the driver a *lot* more readable.
>
> Of note:
>
> * Gets rid of the arbitrary and completely 1:1 mapping of
>  struct brcmf_{core,chip}_priv/struct brcmf_{core,chip} structures
>  which add unreadability whilst offering no real seperation.
>
> * The patch titled HACK - stabilise the value of ->sbwad in use
>  highlights an issue that is either bizarre undocumented behaviour or a
>  genuine bug - without datasheets, I dont know. Essentially the value of =
sbwad
>  is taken as the base address in several functions, even though it is sub=
ject
>  to change should other IO occur that moves the window offset
>
> Obviously this is a first cut at this and needs substantial cleanup itsel=
f,
> however I wanted to get some idea of wether I should continue working on =
this.

I looked at 4 random patches and none got any description. Not to
mention their chaotic subjects. In this state I can't even review it.
If you want to have some change accepted, you've to convince us it's
needed. Work on cleaning your patches and resend them. You also need
to signed off your changes.

--=20
Rafa=C5=82
