Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:52706 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933330AbdERL1o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 07:27:44 -0400
Date: Thu, 18 May 2017 13:27:20 +0200
From: Daniel Golle <daniel@makrotopia.org>
To: Tom Psyborg <pozega.tomislav@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Jes Sorensen <jes.sorensen@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        David Miller <davem@davemloft.net>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Mathias Kresin <dev@kresin.me>,
        Serge Vasilugin <vasilugin@yandex.ru>,
        Roman Yeryomin <roman@advem.lv>
Subject: Re: [PATCH] rt2x00: remove unneccesary code
Message-ID: <20170518112720.GE2239@makrotopia.org> (sfid-20170518_132811_901293_5B0758F7)
References: <CAKR_QVJBSKw2uCY4RbHZPvbGkMcvnBh+j6F+9t93mG3BakjX3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAKR_QVJBSKw2uCY4RbHZPvbGkMcvnBh+j6F+9t93mG3BakjX3Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tom,

thank you for that contribution.
Code for ePA has not yet been submitted upstream, I wanted to give it
some more testing, so it's still a local patch in OpenWrt/LEDE.
I'll merge your patch into our local patch-queue and submit it together
with the ePA code once it got some more testing.

Cheers

Daniel

Patchworkers: consider this to be a request to defer this submission.


On Thu, May 18, 2017 at 12:42:14PM +0200, Tom Psyborg wrote:
> Use chanreg and dccal helpers to reduce the size of ePA code.
> 
> Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
> 
> ---
