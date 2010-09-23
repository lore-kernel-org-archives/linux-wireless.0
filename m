Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50700 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab0IWSK3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 14:10:29 -0400
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
In-Reply-To: <AANLkTimTQ1KP1JDBtSbxiMg-qvSm-Uw7H9EjDyp-WnrJ@mail.gmail.com>
References: <1285201037-29405-1-git-send-email-lrodriguez@atheros.com>
	 <20100923002240.GA4484@tux>
	 <1285231958.3691.10.camel@jlt3.sipsolutions.net>
	 <AANLkTikh+Q0AK+RyouLOQ5RN5wnKaD2TMnHR-ofqrMKJ@mail.gmail.com>
	 <1285254157.3770.169.camel@jlt3.sipsolutions.net>
	 <1285254226.3770.171.camel@jlt3.sipsolutions.net>
	 <AANLkTimTQ1KP1JDBtSbxiMg-qvSm-Uw7H9EjDyp-WnrJ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Sep 2010 20:10:23 +0200
Message-ID: <1285265423.3770.359.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-23 at 11:06 -0700, Luis R. Rodriguez wrote:

> >> > >> [ 3276.730081] BUG: unable to handle kernel NULL pointer dereference at 0000000000000003
> >> > >> [ 3276.730148] IP: [<0000000000000003>] 0x3

> > But still, it's a NULL pointer call, and I can't really see how that
> > would happen.
> 
> Hey so how do we know its a function ?

It says IP is 0x3, so technically it's not even NULL.

johannes

