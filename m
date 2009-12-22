Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:43946 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbZLVK4R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 05:56:17 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NN2PP-0006fX-A2
	for linux-wireless@vger.kernel.org; Tue, 22 Dec 2009 11:56:07 +0100
Received: from p4FF0CDDD.dip.t-dialin.net ([79.240.205.221])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 22 Dec 2009 11:56:07 +0100
Received: from Markus_Baier by p4FF0CDDD.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 22 Dec 2009 11:56:07 +0100
To: linux-wireless@vger.kernel.org
From: Markus Baier <Markus_Baier@web.de>
Subject: Re: [BISECTED] [PATCH v2 8/8] rt2x00: Properly request tx headroom for alignment operations.
Date: Tue, 22 Dec 2009 10:55:27 +0000 (UTC)
Message-ID: <loom.20091222T114501-773@post.gmane.org>
References: <1259012694-14869-1-git-send-email-gwingerde@gmail.com>	 <1259012694-14869-2-git-send-email-gwingerde@gmail.com>	 <1259012694-14869-3-git-send-email-gwingerde@gmail.com>	 <1259012694-14869-4-git-send-email-gwingerde@gmail.com>	 <1259012694-14869-5-git-send-email-gwingerde@gmail.com>	 <1259012694-14869-6-git-send-email-gwingerde@gmail.com>	 <1259012694-14869-7-git-send-email-gwingerde@gmail.com>	 <1259012694-14869-8-git-send-email-gwingerde@gmail.com>	 <1259012694-14869-9-git-send-email-gwingerde@gmail.com>	 <loom.20091220T163829-137@post.gmane.org> <4B2E8729.7050501@gmail.com>	 <20091221013316.nm9belnhywwwsc0w-cebfxv@webmail.spamcop.net>	 <4B2FA1CF.1010903@gmail.com> <1261459549.31982.2.camel@ct> <4B307FB1.5040806@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gertjan van Wingerde <gwingerde@...> writes:

> Can you confirm that everything works okay with the original code
> and this patch applied?

I restored the original patch from 2.6.33-rc1-wl
and applied the patch from Pavel Roskin.
Now it works. Thanks!

Regards
Markus



