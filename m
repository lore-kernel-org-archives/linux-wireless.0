Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:59774 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbYFFR4X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2008 13:56:23 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Chris Wright <chrisw@sous-sol.org>
Subject: Re: [stable] [PATCH stable] b43: Fix controller restart crash
Date: Fri, 6 Jun 2008 19:55:27 +0200
Cc: stable@kernel.org, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de,
	John Linville <linville@tuxdriver.com>
References: <200806061558.42998.mb@bu3sch.de> <20080606173223.GR30402@sequoia.sous-sol.org>
In-Reply-To: <20080606173223.GR30402@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200806061955.27951.mb@bu3sch.de> (sfid-20080606_195629_154459_B981DD3E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 06 June 2008 19:32:23 Chris Wright wrote:
> * Michael Buesch (mb@bu3sch.de) wrote:
> > This fixes a kernel crash on rmmod, in the case where the controller
> > was restarted before doing the rmmod.
> > 
> > Upstream commit is 4735f5022c97f6624ced2ec5056c61c4b437d53b
> 
> This is not in Linus' tree.  Where is this upstream commit?

John Linville's wireless tree. That's upstream from my point of view. :P


-- 
Greetings Michael.
