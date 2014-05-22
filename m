Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39747 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbaEVJAF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 05:00:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1WnOr5-0001Xp-Jy
	for linux-wireless@vger.kernel.org; Thu, 22 May 2014 11:00:03 +0200
Received: from 222-146.wlan.uni-rostock.de ([139.30.222.146])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 11:00:03 +0200
Received: from hannesraddatz by 222-146.wlan.uni-rostock.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 11:00:03 +0200
To: linux-wireless@vger.kernel.org
From: Hannes Raddatz <hannesraddatz@t-online.de>
Subject: Re: wireless network interfaces and network namespaces
Date: Thu, 22 May 2014 08:54:22 +0000 (UTC)
Message-ID: <loom.20140522T103749-45@post.gmane.org> (sfid-20140522_110010_318489_4E08B72C)
References: <CAGXs5wXPB2WvuxfXzuyDaGS5_cA+GG5vHkHO+PnnVncvOwJTDg@mail.gmail.com>  <1385817282.5056.0.camel@jlt4.sipsolutions.net>  <CAGXs5wVt3okeE6oA_pNV5WnQLv51+bf+n+52s5d7tQkXq_qvNw@mail.gmail.com>  (sfid-20131130_145812_659093_751E3F17) <1385840149.4267.1.camel@jlt4.sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I would like to dig this thread out, 
because there might be a bug regarding this topic.

Using ubuntu 12.10, the move of virtual wirless devices (hwsim) to a 
namespace and 
configuring them inside the namespace with iw wasn't a problem. 
But since ubuntu 14.04 I can't 
access the devices inside the namespace with iw.
The same problem occurs while using 
ubuntu 12.10 with newest backports installed.
Has something changed with the namespaces in 
the new linux kernels or is it a bug?

br,
Hannes

