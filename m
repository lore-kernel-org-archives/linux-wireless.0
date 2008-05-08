Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2751 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755797AbYEHB7m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2008 21:59:42 -0400
Date: Wed, 7 May 2008 21:43:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, akpm@linux-foundation.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: New GIT net tree naming...
Message-ID: <20080508014358.GE3412@tuxdriver.com> (sfid-20080508_035851_946793_8B727691)
References: <20080419.173510.257216556.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080419.173510.257216556.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 19, 2008 at 05:35:10PM -0700, David Miller wrote:
> 
> Based upon feedback from Andrew and others I'm now starting
> to use a new naming scheme for my GIT trees:
> 
> For changes against Linus's current tree:
> 
>    master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git
> 
> For development meant to be merged in the next merge
> window we have:
> 
>    master.kernel.org:/pub/scm/linux/kernel/git/davem/net-next-2.6.git
> 
> Andrew/Stephen, let me know if this works for you.  This way
> the tree names will never change.

I have adopted this same scheme for wireless as well:

For changes against Linus's current tree:

   master.kernel.org:/pub/scm/linux/kernel/git/linville/wireless-2.6.git

For development meant to be merged in the next merge
window we have:

   master.kernel.org:/pub/scm/linux/kernel/git/linville/wireless-next-2.6.git

John
-- 
John W. Linville
linville@tuxdriver.com
