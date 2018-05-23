Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:58766 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751007AbeEWPvh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 11:51:37 -0400
Date: Wed, 23 May 2018 11:51:34 -0400 (EDT)
Message-Id: <20180523.115134.1971221580030176879.davem@davemloft.net> (sfid-20180523_175225_878417_A3F691BC)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2018-05-23
From: David Miller <davem@davemloft.net>
In-Reply-To: <20180523094758.8892-1-johannes@sipsolutions.net>
References: <20180523094758.8892-1-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 23 May 2018 11:47:57 +0200

> Just another handful of fixes as we wind down towards the
> merge window.
> 
> Please pull and let me know if there's any problem.

Pulled, thanks Johannes.

Please don't tell me you will soon queue up a patch that
limits wiphy names to 32 bytes :-)
