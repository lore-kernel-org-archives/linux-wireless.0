Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbYCDOBe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 09:01:34 -0500
Subject: Re: Patch for linux wireless extension
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: hce <webmail.hce@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1204626369.3917.96.camel@johannes.berg>
References: <95455e980803031901x67360bffsca3794f1dfde586b@mail.gmail.com>
	 (sfid-20080304_030142_484588_E01052A6)  <1204626369.3917.96.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 08:58:21 -0500
Message-Id: <1204639101.7183.17.camel@localhost.localdomain> (sfid-20080304_140137_664897_86793F14)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-03-04 at 11:26 +0100, Johannes Berg wrote:
> Jim,
> 
> > I am running a wifi device on kernel 2.6.11 and wireless extension
> > version 17 for an ARM processor, it works fine with an open AP and
> > wpa_supplicant 0.5.8. 
> 
> That's ancient.
> 
> > Now I would like to support WEP and WPA. I know
> > the best is to upgrade to latest kernel, but I am not in the position
> > to do it as various reasons. 
> 
> Upgrade anyway.
> 
> > An alternative as people suggested is to
> > do a wireless extension patch which supports WEP and WPA on kernel
> > 2.6.11. Any advice if it is feasible and where can I find the wireless
> > extension patch for WEP and WPA on kernel 2.6.11 please?
> 
> Hahaha. We'll you'll have to *make* that patch and invest a
> *significant* amount of time into that.

Yeah; it's not just the defines and whatnot in wireless.h; you probably
also want to update wireless-tools too, then you have to update your
driver as well.  It's not hugely complex, but it's going to be a lot of
boring work :)

Dan


