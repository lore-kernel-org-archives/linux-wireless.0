Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36921 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758123Ab0EFNpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 09:45:12 -0400
Date: Thu, 6 May 2010 09:43:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rt61pci: WEP broken in current wireless-testing
Message-ID: <20100506134335.GA4167@tuxdriver.com>
References: <20100506075157.whuptq9jgzkww4gs-cebfxv@webmail.spamcop.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100506075157.whuptq9jgzkww4gs-cebfxv@webmail.spamcop.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 06, 2010 at 07:51:57AM -0400, Pavel Roskin wrote:

> Recent changes in wireless-testing have broken WEP support in rt61pci.  
>   An older kernel from wireless-testing identified as 2.6.34-rc5-wl is  
> working fine.

> It's should be rather straightforward to bisect, but I'll be away from  
> that system until next Monday.

When you get to this, you probably should use wireless-next-2.6
(or wireless-2.6) for the bisection.  The pulls from linux-2.6 in
wireless-testing make bisection much more painful than necessary
(as long as the problem is actually evident in the other kernels).
You can use the 'master-<date>' tags as guidelines for matching
wireless-testing versions to representative wireless-next-2.6 (or
wireless-2.6) tree versions.

Hth!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
