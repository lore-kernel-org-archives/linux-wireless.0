Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sous-sol.org ([216.99.217.87]:33564 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932AbYFFRcx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2008 13:32:53 -0400
Date: Fri, 6 Jun 2008 10:32:23 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: stable@kernel.org, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
Subject: Re: [stable] [PATCH stable] b43: Fix controller restart crash
Message-ID: <20080606173223.GR30402@sequoia.sous-sol.org> (sfid-20080606_193257_782382_B87CC4C5)
References: <200806061558.42998.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200806061558.42998.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Michael Buesch (mb@bu3sch.de) wrote:
> This fixes a kernel crash on rmmod, in the case where the controller
> was restarted before doing the rmmod.
> 
> Upstream commit is 4735f5022c97f6624ced2ec5056c61c4b437d53b

This is not in Linus' tree.  Where is this upstream commit?

thanks,
-chris
