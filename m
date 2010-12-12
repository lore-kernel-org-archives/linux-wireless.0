Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:38037 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930Ab0LLKOT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Dec 2010 05:14:19 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PRiwc-0002qv-Vj
	for linux-wireless@vger.kernel.org; Sun, 12 Dec 2010 11:14:18 +0100
Received: from 194.48.133.8 ([194.48.133.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 12 Dec 2010 11:14:18 +0100
Received: from messier31 by 194.48.133.8 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 12 Dec 2010 11:14:18 +0100
To: linux-wireless@vger.kernel.org
From: thomas <messier31@gmx.net>
Subject: Re: carl9170 802.11n-AP
Date: Sun, 12 Dec 2010 10:14:03 +0000 (UTC)
Message-ID: <loom.20101212T110657-413@post.gmane.org>
References: <loom.20101212T101545-636@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just saw that there could be "aggregation stalls" with "any Intel N Wifi
Link". 
I am using Intel Wifi Link 5100 and the driver frequently restarts under
heavy load. 
But it also works perfectly well with close to 100mbit/s for some time.
So are this the "aggregation stalls" mentioned in the description? If yes, what
is the mentioned driver workaround for this?

Regards,

Thomas




