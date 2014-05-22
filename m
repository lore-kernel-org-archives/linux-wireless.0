Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44000 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbaEVKqb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 06:46:31 -0400
Message-ID: <1400755577.4174.10.camel@jlt4.sipsolutions.net> (sfid-20140522_124635_206502_2997F38C)
Subject: Re: wireless network interfaces and network namespaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Hannes Raddatz <hannesraddatz@t-online.de>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 22 May 2014 12:46:17 +0200
In-Reply-To: <loom.20140522T103749-45@post.gmane.org> (sfid-20140522_110010_318489_4E08B72C)
References: <CAGXs5wXPB2WvuxfXzuyDaGS5_cA+GG5vHkHO+PnnVncvOwJTDg@mail.gmail.com>
	  <1385817282.5056.0.camel@jlt4.sipsolutions.net>
	  <CAGXs5wVt3okeE6oA_pNV5WnQLv51+bf+n+52s5d7tQkXq_qvNw@mail.gmail.com>
	  (sfid-20131130_145812_659093_751E3F17) <1385840149.4267.1.camel@jlt4.sipsolutions.net>
	 <loom.20140522T103749-45@post.gmane.org>
	 (sfid-20140522_110010_318489_4E08B72C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-05-22 at 08:54 +0000, Hannes Raddatz wrote:
> I would like to dig this thread out, 
> because there might be a bug regarding this topic.
> 
> Using ubuntu 12.10, the move of virtual wirless devices (hwsim) to a 
> namespace and 
> configuring them inside the namespace with iw wasn't a problem. 
> But since ubuntu 14.04 I can't 
> access the devices inside the namespace with iw.
> The same problem occurs while using 
> ubuntu 12.10 with newest backports installed.
> Has something changed with the namespaces in 
> the new linux kernels or is it a bug?

No idea. Works fine for me on kernel 3.14+mac80211-next.

johannes

