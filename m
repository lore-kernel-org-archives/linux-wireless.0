Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:52793 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011Ab0AWJlN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 04:41:13 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NYcUP-0000VS-Mg
	for linux-wireless@vger.kernel.org; Sat, 23 Jan 2010 10:41:09 +0100
Received: from p4FF0DD95.dip.t-dialin.net ([79.240.221.149])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jan 2010 10:41:09 +0100
Received: from Markus_Baier by p4FF0DD95.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jan 2010 10:41:09 +0100
To: linux-wireless@vger.kernel.org
From: Markus Baier <Markus_Baier@web.de>
Subject: Re: NULL dereference on wireless-testing/head
Date: Sat, 23 Jan 2010 09:40:46 +0000 (UTC)
Message-ID: <loom.20100123T103349-999@post.gmane.org>
References: <297c1a111001222341gad6b26eh8a410a73a2d9a3dc@mail.gmail.com> <87tyudp6bm.fsf@purkki.valot.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kalle.valo@...> writes:

> There are patches from John and Johannes which should fix this. Latest
> wireless-testing contains the patches.

No, this bug was not fixed in the latest wireless-testing version.
Pauls Kernel 2.6.33-rc5-wl (g96ada3c) was compiled from master-2010-01-22

