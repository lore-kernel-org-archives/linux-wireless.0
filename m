Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:14693 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbYAPQhU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2008 11:37:20 -0500
Received: by fg-out-1718.google.com with SMTP id e21so333875fga.17
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jan 2008 08:37:18 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: proper short-slot handling
Date: Wed, 16 Jan 2008 17:37:00 +0100
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Michael Buesch <mb@bu3sch.de>,
	Michael Wu <flamingice@sourmilk.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	bruno randolf <br1@einfach.org>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Yanbo Li <dreamfly281@gmail.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Daniel Drake <dsd@gentoo.org>
References: <1199974496.3861.80.camel@johannes.berg> <200801102000.44722.IvDoorn@gmail.com> <1200490221.5887.170.camel@johannes.berg>
In-Reply-To: <1200490221.5887.170.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200801161737.00682.IvDoorn@gmail.com> (sfid-20080116_163724_317095_0BE13226)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 16 January 2008, Johannes Berg wrote:
> Ivo,
> 
> > > If you think it is the right approach, maybe try converting your driver
> > > and see if that results in any problems, if not, send me the patch and
> > > I'll integrate it.
> > 
> > The convertion was very easy, and like I said cleaned up some hacks. :)
> 
> Thanks. What is this diffed on? I tried importing it into my current
> patch but it failed, do I have to wait for John to pull in your recent
> pull request?

John already merged the 2.0.14 release into the everything branch,
so no need to wait on that. The remaining patches which have been send
but not yet merged are bugfixes which won't cause a collision with the
short-slot patch.

Not sure where I diffed it against, I probably have to rebase it anyway
since I currently have a few major patches pending for the 2.1.0 release
which will drastically change the entire interface handling in rt2x00.

When do you plan to send the patch for inclusion? I can rebase the patch
and make it part of the 2.1.0 release of this weekend or release 2.1.0
and rebase the patch against that.

Ivo
