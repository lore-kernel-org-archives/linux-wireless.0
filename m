Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:56724 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997AbZEKUfC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 16:35:02 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1M3cDH-0001dD-Gr
	for linux-wireless@vger.kernel.org; Mon, 11 May 2009 20:35:03 +0000
Received: from cac94-1-81-57-151-96.fbx.proxad.net ([81.57.151.96])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 11 May 2009 20:35:03 +0000
Received: from castet.matthieu by cac94-1-81-57-151-96.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 11 May 2009 20:35:03 +0000
To: linux-wireless@vger.kernel.org
From: Matthieu CASTET <castet.matthieu@free.fr>
Subject: B43 no beacon ?
Date: Mon, 11 May 2009 20:31:33 +0000 (UTC)
Message-ID: <loom.20090511T202208-851@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have trying to use openwrt head on a router with a 4306 (core rev 5).
It use the compat-wireless-2009-05-08 as wireless driver and 4.150.10.5 firmware

I have no problem to associate and transmit data with one wifi card, but with
another I got missed beacon errors.

After putting a wifi card in monitor mode, I saw that the 4306 never send beacon
frame.

Do you have any idea why the 4306 AP never generate beacon frame ?

Thanks

Matthieu

