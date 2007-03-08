Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:49765 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030744AbXCHWb2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 17:31:28 -0500
Date: Thu, 8 Mar 2007 14:30:58 -0800
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <jkm@devicescape.com>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	netdev <netdev@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
	Dan Williams <dcbw@redhat.com>
Subject: Re: wireless extensions vs. 64-bit architectures
Message-ID: <20070308223058.GA24960@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <20070306171316.GA19669@bougret.hpl.hp.com> <200703061943.07350.mb@bu3sch.de> <20070307020310.GA20466@bougret.hpl.hp.com> <1173364747.14001.7.camel@johannes.berg> <20070308184954.GA24485@bougret.hpl.hp.com> <1173382042.3248.63.camel@johannes.berg> <20070308193412.GG23040@devicescape.com> <1173382802.3248.68.camel@johannes.berg> <20070308221128.GA24884@bougret.hpl.hp.com> <20070308141756.efdfd6da.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070308141756.efdfd6da.randy.dunlap@oracle.com>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 08, 2007 at 02:17:56PM -0800, Randy Dunlap wrote:
> On Thu, 8 Mar 2007 14:11:28 -0800 Jean Tourrilhes wrote:
> > 
> > 	Third possibility : we declare 32 bit userspace on 64 bit
> > kernel as not supported and advise users to get a 64 bit
> > userspace. The number of bug report on that issue would suggest that
> > very few users are in this case.
> 
> I think that this is not actually an option since
> powerpc64 is all 32-bit userspace.
> Maybe some other arch-es are like this also (?).

	Then, I assume that the powerpc64 must be using a magic
version of iwconfig to configure wireless interfaces, because I only
ever got one other bug report on the issue. They should have sent the
patch to Johannes, because now I know about their unauthorised version
of iwconfig.
	Thanks,

	Jean

