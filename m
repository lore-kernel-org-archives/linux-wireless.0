Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:34684 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751543AbdLKOjk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 09:39:40 -0500
Date: Mon, 11 Dec 2017 09:39:38 -0500 (EST)
Message-Id: <20171211.093938.774680202624437063.davem@davemloft.net> (sfid-20171211_153954_501319_D3D236E1)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2017-12-11
From: David Miller <davem@davemloft.net>
In-Reply-To: <20171211095236.10172-1-johannes@sipsolutions.net>
References: <20171211095236.10172-1-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Mon, 11 Dec 2017 10:52:35 +0100

> Three fixes, two related to build issues with the new regdb stuff,
> and one for some patch overlap problem that caused locking to be
> missing which in turn caused lots of warnings.
> 
> Please pull and let me know if there's any problem.

Pulled, thanks.
