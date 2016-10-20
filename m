Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:44410 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933158AbcJTSiC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Oct 2016 14:38:02 -0400
Date: Thu, 20 Oct 2016 14:38:00 -0400 (EDT)
Message-Id: <20161020.143800.2192559431314444033.davem@davemloft.net> (sfid-20161020_204123_342168_2663ECF0)
To: johannes@sipsolutions.net
Cc: jarod@redhat.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        qca_merez@qca.qualcomm.com, simon@thekelleys.org.uk,
        stas.yakovlev@gmail.com, inaky.perez-gonzalez@intel.com
Subject: Re: [PATCH net-next v2 3/9] net: use core MTU range checking in
 wireless drivers
From: David Miller <davem@davemloft.net>
In-Reply-To: <1476987755.14078.3.camel@sipsolutions.net>
References: <20161020175524.6184-1-jarod@redhat.com>
        <20161020175524.6184-4-jarod@redhat.com>
        <1476987755.14078.3.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Thu, 20 Oct 2016 20:22:35 +0200

> On Thu, 2016-10-20 at 13:55 -0400, Jarod Wilson wrote:
>> - set max_mtu in wil6210 driver
>> - set max_mtu in atmel driver
>> - set min/max_mtu in cisco airo driver, remove airo_change_mtu
>> - set min/max_mtu in ipw2100/ipw2200 drivers, remove
>> libipw_change_mtu
>> - set min/max_mtu in p80211netdev, remove wlan_change_mtu
>> - set min/max_mtu in net/mac80211/iface.c and remove ieee80211_change_mtu
> 
> For the mac80211 part,
> 
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
> 
> Dave, I'm assuming you'll pick this up, but if you prefer not to I can
> also coordinate with Kalle to take this through our trees.

Yeah I'll get this, thanks for asking.
