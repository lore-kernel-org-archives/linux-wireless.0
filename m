Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from MAIL1.WPI.EDU ([130.215.36.91]:35672 "EHLO mail1.wpi.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbZCJMpe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 08:45:34 -0400
Date: Tue, 10 Mar 2009 08:45:25 -0400
From: Chuck Anderson <cra@WPI.EDU>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwlagn won't scan 5 GHz band
Message-ID: <20090310124525.GB20351@angus.ind.WPI.EDU> (sfid-20090310_134537_228084_7493AF95)
References: <20090306230124.GU10097@angus.ind.WPI.EDU> <20090307192417.GA6648@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090307192417.GA6648@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 07, 2009 at 02:24:17PM -0500, John W. Linville wrote:
> On Fri, Mar 06, 2009 at 06:01:24PM -0500, Chuck Anderson wrote:
> > Please Cc: me on replies as I'm not subscribed.  Thanks.
> > 
> > I have a 4965, using kernel-2.6.29-0.197.rc7.fc11.x86_64 (Intel(R) 
> > Wireless WiFi Link AGN driver for Linux, 1.3.27kds).  I can connect to 
> > 802.11n on 2.4 GHz, but it never finds the 5 GHz cell of the AP.  Is 5 
> > GHz 802.11n supported yet?  For that matter, shouldn't I be seeing the 
> > 802.11a from my APs?  How do I get this thing to scan the A/N 5 GHz 
> > band?
> 
> Ah, the joys of Rawhide...
> 
> Make sure you have "iw" installed.
> 
> 	yum install iw
> 
> Then you need to specify your regulatory domain:
> 
> 	iw reg set US # Use ISO/IEC 3166-1 alpha2 as appropriate for you
> 
> Does that change things for you?

Works great!

> We are still discussing ways to get this set automatically.  We are
> hoping that NetworkManager grows this capability "soon"...  In the
> meantime, you might try calling the attached script from /etc/rc.local.
> 
> Hth!

Thanks!
