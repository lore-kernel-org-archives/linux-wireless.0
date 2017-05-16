Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:49806 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751752AbdEPPh2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 11:37:28 -0400
Date: Tue, 16 May 2017 11:37:23 -0400 (EDT)
Message-Id: <20170516.113723.631618367518477483.davem@davemloft.net> (sfid-20170516_173810_365774_1478C302)
To: johannes@sipsolutions.net
Cc: sgruszka@redhat.com, arnd@arndb.de, helmut.schaa@googlemail.com,
        kvalo@codeaurora.org, daniel@makrotopia.org, dev@kresin.me,
        pozega.tomislav@gmail.com, vasilugin@yandex.ru, roman@advem.lv,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rt2x00: improve calling conventions for register
 accessors
From: David Miller <davem@davemloft.net>
In-Reply-To: <1494935936.15923.0.camel@sipsolutions.net>
References: <20170515.103951.2305484593464882104.davem@davemloft.net>
        <20170516115511.GA4230@redhat.com>
        <1494935936.15923.0.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 16 May 2017 13:58:56 +0200

> On Tue, 2017-05-16 at 13:55 +0200, Stanislaw Gruszka wrote:
>> 
>> In rt2x00 driver we use poor convention in other kind of registers
>> accessors like bbp, mac, eeprom. I dislike to changing only rfcsr
>> accessors and leaving others in the old way. And changing all
>> accessors would be massive and error prone change, which I'm not
>> prefer either.
> 
> That's a stupid argument, but for the sake of it - the conversion can
> easily be done with coccinelle/spatch without being "error prone".

Agreed, we have tools for this.
