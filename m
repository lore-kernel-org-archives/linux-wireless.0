Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blaine.gmane.org ([80.91.229.8]:38890 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbYAJKRu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 05:17:50 -0500
Received: from public by hugh.gmane.org with local (Exim 4.63)
	(envelope-from <public@hugh.gmane.org>)
	id 1JCtkH-0006xW-8Q
	for linux-wireless@vger.kernel.org; Thu, 10 Jan 2008 10:30:41 +0100
To: Michael Buesch <public-mb-fseUSCV1ubazQB+pC5nmwQ@hugh.gmane.org>
Cc: John Linville
	<public-linville-2XuSBdqkA4R54TAoqtyWWQ@hugh.gmane.org>,
	public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org,
	public-bcm43xx-dev-0fE9KPoRgkgATYTw5x5z8w@hugh.gmane.org
Subject: Re: [PATCH] b43: Add N-PHY register definitions
From: Andi Kleen <andi@firstfloor.org>
References: <200801091613.57304.mb@bu3sch.de>
Date: Thu, 10 Jan 2008 10:30:21 +0100
In-Reply-To: <200801091613.57304.mb@bu3sch.de> (Michael Buesch's message of "Wed\, 9 Jan 2008 16\:13\:56 +0100")
Message-ID: <p73r6gqni36.fsf@bingen.suse.de> (sfid-20080110_101756_307433_249A533D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>




> This patch adds all register definitions for the N-PHY.
> This adds two new files: nphy.h and nphy.c
> No functional changes to existing code.

Do you already have a complete rollup patch adding 4328 support? I would
be interested in testing that.

-Andi

