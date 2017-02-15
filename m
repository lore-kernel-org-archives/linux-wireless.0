Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:36314 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752367AbdBORyG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 12:54:06 -0500
Date: Wed, 15 Feb 2017 12:54:03 -0500 (EST)
Message-Id: <20170215.125403.419777696065228170.davem@davemloft.net> (sfid-20170215_185431_943794_F18DDFBE)
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sgruszka@redhat.com, johannes.berg@intel.com
Subject: Re: [PATCH] average: change to declare precision, not factor
From: David Miller <davem@davemloft.net>
In-Reply-To: <20170215084926.29482-1-johannes@sipsolutions.net>
References: <20170215084926.29482-1-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 15 Feb 2017 09:49:26 +0100

> From: Johannes Berg <johannes.berg@intel.com>
> 
> Declaring the factor is counter-intuitive, and people are prone
> to using small(-ish) values even when that makes no sense.
> 
> Change the DECLARE_EWMA() macro to take the fractional precision,
> in bits, rather than a factor, and update all users.
> 
> While at it, add some more documentation.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> Unless I hear any objections, I will take this through my tree.

Acked-by: David S. Miller <davem@davemloft.net>
