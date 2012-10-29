Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49162 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757386Ab2J2RO5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 13:14:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1TSsvX-0000ug-UK
	for linux-wireless@vger.kernel.org; Mon, 29 Oct 2012 18:15:04 +0100
Received: from 218.36.17.93.rev.sfr.net ([93.17.36.218])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 29 Oct 2012 18:15:03 +0100
Received: from m.chaplet by 218.36.17.93.rev.sfr.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 29 Oct 2012 18:15:03 +0100
To: linux-wireless@vger.kernel.org
From: Martin Chaplet <m.chaplet@kerlink.fr>
Subject: Re: poor performance with W2CBW003 (Marvell 8686)
Date: Mon, 29 Oct 2012 17:10:07 +0000 (UTC)
Message-ID: <loom.20121029T180135-888@post.gmane.org> (sfid-20121029_181500_575418_20D9F2DE)
References: <20120614074545.105a459d@kemnade.info>  <1339690266.19412.YahooMailClassic@web161704.mail.bf1.yahoo.com>  <20120615081850.77454e10@kemnade.info> <1339778927.22782.25.camel@dcbw.foobar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andreas,

I'm facing same issue on a 3.0.X kernel.
I've tried to merge some patches to support SDIO irq on 3.0 kernel but without
success.

Interrupts are triggered and CPU load is greatly improved but performance is not
here (1 Mbps up, 3 Mbps down)

Did you actually get a working "SDIO irq" patch on a recent kernel or did you
finally use 2.6.32 one ?


Thanks,

Martin




