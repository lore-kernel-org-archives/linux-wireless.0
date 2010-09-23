Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48454 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab0IWPCm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 11:02:42 -0400
Subject: Re: [PATCH] wifi-test: add simple roam test script
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	"jiajia.zheng@intel.com" <jiajia.zheng@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"wifi-test-devel@lists.sourceforge.net"
	<wifi-test-devel@lists.sourceforge.net>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Paul Stewart <pstew@google.com>
In-Reply-To: <AANLkTikh+Q0AK+RyouLOQ5RN5wnKaD2TMnHR-ofqrMKJ@mail.gmail.com>
References: <1285201037-29405-1-git-send-email-lrodriguez@atheros.com>
	 <20100923002240.GA4484@tux>
	 <1285231958.3691.10.camel@jlt3.sipsolutions.net>
	 <AANLkTikh+Q0AK+RyouLOQ5RN5wnKaD2TMnHR-ofqrMKJ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Sep 2010 17:02:37 +0200
Message-ID: <1285254157.3770.169.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-23 at 07:53 -0700, Luis R. Rodriguez wrote:

> >> After roaming for a good while, this is what I got, not sure
> >> yet what caused the NULL pointer dereference... Am I the only
> >> one able to reproduce this?
> >
> >> [ 3276.730081] BUG: unable to handle kernel NULL pointer dereference at 0000000000000003
> >> [ 3276.730148] IP: [<0000000000000003>] 0x3
> >
> > Something called a NULL pointer function pointer. Rafael recently said
> > "cpuidle is buggy" when a similar issue came up:
> > http://mid.gmane.org/201009182344.12498.rjw@sisk.pl
> 
> But that seems related to ACPI, no? On my box I never suspended, I
> just associated and disassociated rapidly between two peers. The only
> suspicion I have is its obviously right after adding the STA peer.

Yes, but he said suspend/resume _fixed_ it :-)

johannes

