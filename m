Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:51500 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750802AbeBVURp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Feb 2018 15:17:45 -0500
Date: Thu, 22 Feb 2018 15:17:43 -0500 (EST)
Message-Id: <20180222.151743.580590710914741803.davem@davemloft.net> (sfid-20180222_211752_462086_77F856C5)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2018-02-22
From: David Miller <davem@davemloft.net>
In-Reply-To: <20180222200840.26982-1-johannes@sipsolutions.net>
References: <20180222200840.26982-1-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Thu, 22 Feb 2018 21:08:39 +0100

> A bunch of fixes, including the nla_put_string() issue
> just in from Kees. Otherwise nothing really super urgent
> or interesting.
> 
> Please pull and let me know if there's any problem.

Pulled.

Thanks for taking care of that NLA_STRING thing so fast.
