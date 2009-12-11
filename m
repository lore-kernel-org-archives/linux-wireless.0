Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:47612 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbZLKNTF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 08:19:05 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NJ5Oo-0005Aq-8P
	for linux-wireless@vger.kernel.org; Fri, 11 Dec 2009 14:19:10 +0100
Received: from p4FF0D4EA.dip.t-dialin.net ([79.240.212.234])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 11 Dec 2009 14:19:10 +0100
Received: from Markus_Baier by p4FF0D4EA.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 11 Dec 2009 14:19:10 +0100
To: linux-wireless@vger.kernel.org
From: Markus Baier <Markus_Baier@web.de>
Subject: Re: [RFC] mac80211: disallow bridging managed/adhoc interfaces
Date: Fri, 11 Dec 2009 13:18:44 +0000 (UTC)
Message-ID: <loom.20091211T141516-495@post.gmane.org>
References: <1258465585.3682.7.camel@johannes.local>  <loom.20091211T133913-639@post.gmane.org> <1260536425.2442.199.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, thanks for the fast reply

Ok, that is my fault.
At the moment I bridge the interfaces at boot time
before the start of the hostapd daemon.

So I will remove the wlan0 line from bridge section
of the gentoo net rc-script and hope that hostapd
will take over that task.

Tanks,
Markus

