Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:42140 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245Ab0AVVAP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 16:00:15 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NYQbx-0001Az-KB
	for linux-wireless@vger.kernel.org; Fri, 22 Jan 2010 22:00:09 +0100
Received: from p4FF0DD95.dip.t-dialin.net ([79.240.221.149])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jan 2010 22:00:09 +0100
Received: from Markus_Baier by p4FF0DD95.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jan 2010 22:00:09 +0100
To: linux-wireless@vger.kernel.org
From: Markus Baier <Markus_Baier@web.de>
Subject: Re: Starting hostapd causes kernel panic
Date: Fri, 22 Jan 2010 20:59:47 +0000 (UTC)
Message-ID: <loom.20100122T215904-83@post.gmane.org>
References: <loom.20100122T205326-794@post.gmane.org> <eba66e02dda0a3ec904374a80ea9a1e9@127.0.0.1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 <pat-lkml@...> writes:

> On my system, it doesnt' fail until 
> something actively scans and we receive the probe.

I thinks its the same here.

That would explain the following behavior.
If I started the hostapd deamon in the cellar,
where I can access the console server to capture the trace,
I was able to start the service and the panic appeared
when I stopped the hostap deamon.

When I start it at the upper flor where the AP can
receive many WLAN stations the kernel panic appears instantly
after the start of the deamon.

