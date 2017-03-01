Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:55970 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753587AbdCBDYV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Mar 2017 22:24:21 -0500
Date: Wed, 01 Mar 2017 15:09:39 -0800 (PST)
Message-Id: <20170301.150939.1418366532271934812.davem@davemloft.net> (sfid-20170302_042425_780957_D1E16253)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2017-02-28
From: David Miller <davem@davemloft.net>
In-Reply-To: <20170228095019.10637-1-johannes@sipsolutions.net>
References: <20170228095019.10637-1-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 28 Feb 2017 10:50:18 +0100

> First round of fixes - we actually have quite a few.
> 
> Please pull and let me know if there's any problem.

Pulled, thanks Johannes.

> I had another question - I have this average.h API change pending
> (you saw it before). It seems it might be a good time to get it in
> now, since no new users should be showing up. If I put it in only
> with the next merge window, new users might show up and break.

Ok, you can feel free to send this now for 'net' if you like.
