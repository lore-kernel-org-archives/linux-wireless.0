Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38488 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754241AbdERMRL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 08:17:11 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Jes Sorensen <jes.sorensen@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        David Miller <davem@davemloft.net>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Mathias Kresin <dev@kresin.me>,
        Serge Vasilugin <vasilugin@yandex.ru>,
        Roman Yeryomin <roman@advem.lv>
Subject: Re: [PATCH] rt2x00: remove unneccesary code
References: <CAKR_QVJBSKw2uCY4RbHZPvbGkMcvnBh+j6F+9t93mG3BakjX3Q@mail.gmail.com>
        <20170518112720.GE2239@makrotopia.org>
Date: Thu, 18 May 2017 15:17:02 +0300
In-Reply-To: <20170518112720.GE2239@makrotopia.org> (Daniel Golle's message of
        "Thu, 18 May 2017 13:27:20 +0200")
Message-ID: <874lwixsu9.fsf@kamboji.qca.qualcomm.com> (sfid-20170518_141720_841864_AC2A9102)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(fixing top posting)

Daniel Golle <daniel@makrotopia.org> writes:

> On Thu, May 18, 2017 at 12:42:14PM +0200, Tom Psyborg wrote:
>> Use chanreg and dccal helpers to reduce the size of ePA code.
>>=20
>> Signed-off-by: Tomislav Po=C5=BEega <pozega.tomislav@gmail.com>
>
> thank you for that contribution.
> Code for ePA has not yet been submitted upstream, I wanted to give it
> some more testing, so it's still a local patch in OpenWrt/LEDE.
> I'll merge your patch into our local patch-queue and submit it together
> with the ePA code once it got some more testing.
>
> Patchworkers: consider this to be a request to defer this submission.

This patch was sent in HTML format so it didn't get to mailing list and
hence neither to patchwork.

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes#format_issues

--=20
Kalle Valo
