Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40857 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204Ab2GQTkb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 15:40:31 -0400
Date: Tue, 17 Jul 2012 15:30:33 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: wireless.git frozen -- Re: That's pretty much it for 3.5.0
Message-ID: <20120717193032.GA11732@tuxdriver.com> (sfid-20120717_214043_174945_A51A6746)
References: <20120717.090142.125145009944045241.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120717.090142.125145009944045241.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 17, 2012 at 09:01:42AM -0700, David Miller wrote:
> 
> Linus was _extremely_ generous and took in all the stuff that was
> pending in the net tree just now.
> 
> Besides very serious issues, I'm not willing to consider any more bug
> fixes for the 'net' tree at this time.
> 
> Only one pending known bug qualifies, and that's the CIPSO ip option
> processing OOPS'er.  And I'll work on that myself if Paul Moore
> doesn't show a sign of life in the next day.
> 
> Thanks.

Now only fixes for truly "show stopper" bugs will be accepted for
the 3.5 stream.  I don't believe that any of the handful of fixes
currently in wireless.git (but not yet in net.git) are sufficiently
important to make the cut.

I will pull the current wireless.git tree into the wireless-next.git
tree, and then wireless.git will remain frozen until 3.6-rc1 is
released.  If you have a wireless fix that you believe is sufficiently
important to merit being in 3.5, then please post it to the netdev
list (and Cc: linville@tuxdriver.com when you do so).

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
