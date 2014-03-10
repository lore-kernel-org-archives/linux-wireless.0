Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:45351 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbaCJSLj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2014 14:11:39 -0400
Date: Mon, 10 Mar 2014 14:11:37 -0400 (EDT)
Message-Id: <20140310.141137.446886429226185509.davem@davemloft.net> (sfid-20140310_191216_945662_627E7A4D)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2014-03-07
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140307211239.GC12787@tuxdriver.com>
References: <20140307211239.GC12787@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 7 Mar 2014 16:12:39 -0500

> Please pull this batch of fixes intende for the 3.14 stream...
> 
> For the mac80211 bits, Johannes says:
> 
> "Here I have a fix from Eliad for the minimal channel width calculation
> in the mac80211 code which lead to monitor mode not working at all for
> drivers using that. One of my fixes is for an issue noticed by Michal,
> we clear an already cleared value but do it without locking, so just
> remove that. The other is for a data leak - we leak two bytes of kernel
> memory out over the air in QoS NULL frames because those don't get a
> sequence number assigned in the TX path."
> 
> For the iwlwifi bits, Emmanuel says:
> 
> "One more fix and an update for device IDs.
> There is a bugzilla reported for the fix which is mentioned in the commit message."
> 
> Along with those...
> 
> Amitkumar Karwar provides two mwifiex fixes, both correcting some
> data transcription problems.
> 
> Ivaylo Dimitrov uses skb_trim in the wl1251 driver to avoid
> HAVE_EFFICIENT_UNALIGNED_ACCESS problems.
> 
> Please let me know if there are problems!

Pulled, thanks John.

But we're getting really late in the -rc at this point, please limit 'net'
pull requests to absolutely the most critical bug fixes from here on out.

Thanks again.
