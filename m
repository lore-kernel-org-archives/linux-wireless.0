Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:35060 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053Ab0AWVkK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 16:40:10 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NYniA-0005l3-Pm
	for linux-wireless@vger.kernel.org; Sat, 23 Jan 2010 22:40:06 +0100
Received: from p4FF0D192.dip.t-dialin.net ([79.240.209.146])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jan 2010 22:40:06 +0100
Received: from Markus_Baier by p4FF0D192.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jan 2010 22:40:06 +0100
To: linux-wireless@vger.kernel.org
From: Markus Baier <Markus_Baier@web.de>
Subject: Re: [PATCH] mac80211: fix tx select key null pointer crash with hostapd
Date: Sat, 23 Jan 2010 21:39:41 +0000 (UTC)
Message-ID: <loom.20100123T223757-489@post.gmane.org>
References: <20100123182714.15374.3093.stgit@tikku>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Pavel, Johannes, Kalle

With this patch the kernel works fine again.

