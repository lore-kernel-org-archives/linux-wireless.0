Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:34614 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758882AbdEVSDm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 May 2017 14:03:42 -0400
From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH v2 00/10] rt2x00: rt2x00: improve calling conventions for
 register accessors
To: Arnd Bergmann <arnd@arndb.de>,
        linux-wireless <linux-wireless@vger.kernel.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        David Miller <davem@davemloft.net>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>,
        Johannes Berg <johannes.berg@intel.com>,
        Serge Vasilugin <vasilugin@yandex.ru>,
        Roman Yeryomin <roman@advem.lv>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tom Psyborg <pozega.tomislav@gmail.com>
References: <20170517144702.1381136-1-arnd@arndb.de>
Message-ID: <69171f99-0844-cfe1-7bcb-72d61f56c3c5@gmail.com> (sfid-20170522_200452_973750_50688D60)
Date: Mon, 22 May 2017 14:03:39 -0400
MIME-Version: 1.0
In-Reply-To: <20170517144702.1381136-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/17/2017 10:46 AM, Arnd Bergmann wrote:
> I've managed to split up my long patch into a series of reasonble
> steps now.
> 
> The first two are required to fix a regression from commit 41977e86c984
> ("rt2x00: add support for MT7620"), the rest are just cleanups to
> have a consistent state across all the register access functions.
> 
>       Arnd

Nice work! This is a textbook example of how to do this the right way!

Reviewed-by: Jes Sorensen <jsorensen@fb.com>

Jes
