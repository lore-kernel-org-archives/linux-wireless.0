Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:41770 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754373Ab0AVVuu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 16:50:50 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NYROv-0006Qm-A7
	for linux-wireless@vger.kernel.org; Fri, 22 Jan 2010 22:50:45 +0100
Received: from p4FF0DD95.dip.t-dialin.net ([79.240.221.149])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jan 2010 22:50:45 +0100
Received: from Markus_Baier by p4FF0DD95.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jan 2010 22:50:45 +0100
To: linux-wireless@vger.kernel.org
From: Markus Baier <Markus_Baier@web.de>
Subject: Re: Starting hostapd causes kernel panic
Date: Fri, 22 Jan 2010 21:50:16 +0000 (UTC)
Message-ID: <loom.20100122T224622-417@post.gmane.org>
References: <loom.20100122T205326-794@post.gmane.org>  <1264193623.2593.17.camel@johannes.local> <1264196526.3040.3.camel@mj>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin <proski@...> writes:

> I'm still getting a panic in ieee80211_tx_h_select_key():

Same here :-(

I will compile again, now with CONFIG_MAC80211_NOINLINE
and CONFIG_MAC80211_DEBUG_MENU enabled.

