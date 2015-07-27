Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60558 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbbG0OYN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2015 10:24:13 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1ZJjJS-0004Jf-AG
	for linux-wireless@vger.kernel.org; Mon, 27 Jul 2015 16:23:30 +0200
Received: from 37.160.198.195 ([37.160.198.195])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2015 16:23:30 +0200
Received: from j.cubizolles by 37.160.198.195 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2015 16:23:30 +0200
To: linux-wireless@vger.kernel.org
From: Julien Cubizolles <j.cubizolles@free.fr>
Subject: Re: wifi freezing (module mwifiex)
Date: Mon, 27 Jul 2015 16:23:11 +0200
Message-ID: <87si89k7cg.fsf@free.fr> (sfid-20150727_162439_087760_C7506F7D)
References: <871tfzast5.fsf@free.fr>
	<0e2dc4e2bd9f4486979cedb4c47e60f2@SC-EXCH04.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com>
writes:

> Hi Julien,

> Thanks for reporting the problem. We now have a separate mechanism for
> debug logs and don't support dynamic debugging anymore.
> Issue below command to enable logs and share them.
>
> "echo 0xffffffff > /sys/kernel/debug/mwifiex/mlan0/debug_mask"

Thanks, I'll give it a try next time I have a similar problem. But I
have very good (at least for me) news:

> Do you have following USB chipset specific fixes included?
> http://www.spinics.net/lists/linux-wireless/msg129129.html

This one was already included.

> http://www.spinics.net/lists/netdev/msg334367.html

This one wasn't. I applied the patch and so far (after several MB
downloaded) no freeze. Thanks a lot.

I'm surprised that this patch wasn't included in the 4.2.0-rc3. When is
it due ?


