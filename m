Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36562 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752677AbXLOWOC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Dec 2007 17:14:02 -0500
Subject: Re: [WIP][PATCH] rc80211_pid: Send events to userspace for
	debugging
From: Mattias Nissler <mattias.nissler@gmx.de>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20071215175656.GB3096@tuxdriver.com>
References: <1197414686.7030.27.camel@localhost>
	 <20071214231452.21ece93d@morte>  <20071215175656.GB3096@tuxdriver.com>
Content-Type: text/plain
Date: Sat, 15 Dec 2007 23:13:58 +0100
Message-Id: <1197756838.7540.12.camel@localhost> (sfid-20071215_221414_482125_4BD17AFF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sat, 2007-12-15 at 12:56 -0500, John W. Linville wrote:
> On Fri, Dec 14, 2007 at 11:14:52PM +0100, Stefano Brivio wrote:
> > Here comes an amended patch which works with my tree and should be more
> > mergeable (as it splits the debugfs stuff to another file) just for
> > convenience and to save Mattias some hassle. Hope this helps.
> 
> Speaking of mergeable, we need some "final" patches RSN if we want
> to have this available in 2.6.25.  So, are we satisified with it?

I'm still tuning, testing, etc. I hope we can get a polished patch set
ready by the end of Sunday.

Mattias

