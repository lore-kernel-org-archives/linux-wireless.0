Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2229 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759370AbXI0VJI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 17:09:08 -0400
Date: Thu, 27 Sep 2007 16:36:50 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
	linux-wireless@vger.kernel.org, rjwysocki@sisk.pl,
	Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] libertas: fix link errors (bz# 9077)
Message-ID: <20070927203650.GD7991@tuxdriver.com>
References: <20070927101742.44146651.randy.dunlap@oracle.com> <1190915263.5021.8.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1190915263.5021.8.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 27, 2007 at 07:47:43PM +0200, Johannes Berg wrote:
> On Thu, 2007-09-27 at 10:17 -0700, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Fix missing symbols in libertas USB driver when it is modular and rest
> > of libertas is built-in.
> 
> Ohhh. Thanks Randy, I stared at this problem for a while and never
> noticed that it said _USB there.

FWIW, the equivalent change seems to already be in net-2.6.24.

John
-- 
John W. Linville
linville@tuxdriver.com
