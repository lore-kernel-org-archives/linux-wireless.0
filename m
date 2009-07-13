Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:34767 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbZGMTJv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 15:09:51 -0400
Subject: Re: nl80211 and wext interoperability
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1247507677.4166.27.camel@johannes.local>
References: <1247139797.2144.27.camel@johannes.local>
	 <43e72e890907091053s59ed356er22c59944efec9a01@mail.gmail.com>
	 <1247163342.22527.2.camel@johannes.local>
	 <1247507618.4369.11.camel@localhost.localdomain>
	 <1247507677.4166.27.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 13 Jul 2009 15:10:06 -0400
Message-Id: <1247512206.4369.67.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-07-13 at 19:54 +0200, Johannes Berg wrote:
> On Mon, 2009-07-13 at 13:53 -0400, Dan Williams wrote:
> 
> > Mainly because there's no way to tell WEXT drivers to "stop whatever
> > you're doing and just be idle"...
> > 
> > The supplicant clears out the keys on TERM anyway, and in some cases
> > (iwlagn) the driver will keep trying to reassociate internally
> 
> Seems unlikely, ITYM ipw?

Nope.  I saw this behavior with iwlagn (both 3945 and 4965) when I was
doing all that hidden stuff back in April with 2.6.27 kernels.  Might be
different in very recent kernels?

Dan


