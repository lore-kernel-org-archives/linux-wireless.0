Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49254 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab0HEUFp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 16:05:45 -0400
Subject: Re: [PATCH] cfg80211: support sysfs namespaces
From: Johannes Berg <johannes@sipsolutions.net>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>
In-Reply-To: <m1wrs47shi.fsf@fess.ebiederm.org>
References: <1281023115.4058.11.camel@jlt3.sipsolutions.net>
	 <m1wrs47shi.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 22:05:30 +0200
Message-ID: <1281038730.4058.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-08-05 at 12:46 -0700, Eric W. Biederman wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > Enable using network namespaces with
> > wireless devices even when sysfs is
> > enabled using the same infrastructure
> > that was built for netdevs.
> 
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> This looks reasonable.  I assume you have tested this and it is
> working now?

Yes, I tested it. Was missing the no-op device_rename() at first, but
now it works.

johannes

