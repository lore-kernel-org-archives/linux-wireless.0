Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:42124 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755140AbcJRO0q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 10:26:46 -0400
Date: Tue, 18 Oct 2016 10:26:45 -0400 (EDT)
Message-Id: <20161018.102645.77065965118492040.davem@davemloft.net> (sfid-20161018_162655_664716_8FA89721)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2016-10-18
From: David Miller <davem@davemloft.net>
In-Reply-To: <1476774058-9279-1-git-send-email-johannes@sipsolutions.net>
References: <1476774058-9279-1-git-send-email-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 18 Oct 2016 09:00:57 +0200

> As I mention in the tag message, the most urgent fix here is for
> the VMAP_STACK vs. software crypto usage. I ended up applying Ard's
> fix that dynamically allocates everything in one go, perhaps we'll
> find a better solution in the future, but in the meantime this will
> get things working again (rather than crashing or getting BUG_ON),
> and normally it's a rarely used code path since hardware crypto is
> used for almost all devices.
> 
> Please pull, or let me know if there's any problem.

Pulled, thanks Johannes.
