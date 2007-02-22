Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3894 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbXBVSVb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Feb 2007 13:21:31 -0500
Date: Thu, 22 Feb 2007 13:11:11 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "ivan.muccini@witech.it" <ivan.muccini@witech.it>
Cc: linux-wireless@vger.kernel.org
Subject: Re: 802.11s is possible
Message-ID: <20070222181111.GE5631@tuxdriver.com>
References: <45ddd0c2.b2.681a.1375331394@webmailh5.aruba.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <45ddd0c2.b2.681a.1375331394@webmailh5.aruba.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 22, 2007 at 06:20:02PM +0100, ivan.muccini@witech.it wrote:
> Hi, i'm italian student. I want experiment a channel
> assignment algorithm in 802.11s mesh network. I think to use
> madwifi driver for develop 802.11 feature, like new mesh
> header in MAC header of Data frame, beacon, probe message
> and association. Moreover I need to create new information
> elemnt for HWMP routing protcol.
> Becouse i am new in madwifi, i'm asking you if is possible
> do this whit madwifi.

You'll have to look elsewhere for madwifi.  This list is for work
destined for inclusion in the Linux kernel itself.  If you must use
Atheros hardware, then please consider working in the ar5k-based
dadwifi branch of the madwifi project.  That may have a future in
the upstream kernel.

However, please consider using the Devicescape-originated stack which
we here are working to have included in the upstream kernel "soon".  If you
are familiar with git, you can get the sources from the tree here:

	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-dev.git

If you would prefer a stack of patches (over 700!) to apply on top
of a current tree from Linus, you may want to look here:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-dev/mm-master

If that is unappealing but you are a Fedora user, you may want to
look at my test kernels here:

	http://people.redhat.com/linville/kernels/fc6/

Or my Fedora-netdev kernels available through yum by following the
instructions here:

	http://people.redhat.com/linville/kernels/fedora-netdev/

And if none of those apply, you may wish to stick to Ralink rt2x00 or
Intel ipw3945 hardware.  Each of those projects maintains a snapshot
of the Devicescape-originated stack for use with their own drivers.

As for help with understanding the stack code, Devicescape has some
documentation available at their site.	And, of course, the code
itself is the best reference.  :-)

Hth!

John
-- 
John W. Linville
linville@tuxdriver.com
