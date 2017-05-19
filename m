Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39638 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750748AbdESFTF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 01:19:05 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        David Miller <davem@davemloft.net>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>,
        Johannes Berg <johannes.berg@intel.com>,
        Serge Vasilugin <vasilugin@yandex.ru>,
        Roman Yeryomin <roman@advem.lv>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jes Sorensen <jes.sorensen@gmail.com>,
        Tom Psyborg <pozega.tomislav@gmail.com>
Subject: Re: [PATCH v2 00/10] rt2x00: rt2x00: improve calling conventions for register accessors
References: <20170517144702.1381136-1-arnd@arndb.de>
Date: Fri, 19 May 2017 08:18:57 +0300
In-Reply-To: <20170517144702.1381136-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Wed, 17 May 2017 16:46:52 +0200")
Message-ID: <87r2zl8lvi.fsf@codeaurora.org> (sfid-20170519_071911_324318_0AE03BA4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> writes:

> I've managed to split up my long patch into a series of reasonble
> steps now.
>
> The first two are required to fix a regression from commit 41977e86c984
> ("rt2x00: add support for MT7620"), the rest are just cleanups to
> have a consistent state across all the register access functions.

Can these all go to 4.13 or would you prefer me to push the first two
4.12? Or what?

-- 
Kalle Valo
