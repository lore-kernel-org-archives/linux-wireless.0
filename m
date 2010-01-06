Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46835 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab0AFBAa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 20:00:30 -0500
Date: Tue, 5 Jan 2010 19:58:12 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: rossi.f@inwind.it, linux-wireless@vger.kernel.org
Subject: Re: problem with 2.6.33-rc2 tagging
Message-ID: <20100106005812.GA6361@tuxdriver.com>
References: <201001060021.41202.rossi.f@inwind.it> <20100105.155539.138677861.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100105.155539.138677861.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 05, 2010 at 03:55:39PM -0800, David Miller wrote:
> From: Fabio Rossi <rossi.f@inwind.it>
> Date: Wed, 6 Jan 2010 00:21:41 +0100
> 
> > it seems that the current wireless.git misses a tag for the 2.6.33-rc2 kernel.
> 
> This happens in my net-2.6 tree too, when we pull in upstream
> we just pull in the origin's master branch and not all of the
> tags.

He's probably talking about wireless-testing.  I just updated the tags -- thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
