Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:61142 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754156AbdEQOrv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 May 2017 10:47:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
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
        Jes Sorensen <jes.sorensen@gmail.com>,
        Tom Psyborg <pozega.tomislav@gmail.com>
Subject: [PATCH v2 00/10] rt2x00: rt2x00: improve calling conventions for register accessors
Date: Wed, 17 May 2017 16:46:52 +0200
Message-Id: <20170517144702.1381136-1-arnd@arndb.de> (sfid-20170517_165105_640072_04F58E1D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've managed to split up my long patch into a series of reasonble
steps now.

The first two are required to fix a regression from commit 41977e86c984
("rt2x00: add support for MT7620"), the rest are just cleanups to
have a consistent state across all the register access functions.

     Arnd
