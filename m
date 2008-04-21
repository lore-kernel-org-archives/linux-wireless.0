Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603AbYDUSIu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 14:08:50 -0400
Subject: Re: iwl4965: slow scans
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-wireless@vger.kernel.org
In-Reply-To: <20080421174122.GA10857@tuxdriver.com>
References: <20080421160318.GA19802@phobos.i.cabal.ca>
	 <20080421174122.GA10857@tuxdriver.com>
Content-Type: text/plain
Date: Mon, 21 Apr 2008 14:02:56 -0400
Message-Id: <1208800976.32409.0.camel@localhost.localdomain> (sfid-20080421_200940_241226_12B3FAF1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-04-21 at 13:41 -0400, John W. Linville wrote:
> On Mon, Apr 21, 2008 at 12:03:18PM -0400, Kyle McMartin wrote:
> 
> > I've noticed recently in rawhide that scanning for networks when I come
> > back from suspend takes an age. It seems to be upwards of 3~4 minutes
> > before I'm able to reassociate with my ap.
> > 
> > I'm pulling a pile of rpms to figure out when the change to
> > linux-2.6-wireless*.patch might have caused this (it doesn't *seem* to
> > happen on upstream, but since the patch might make it to upstream soon,
> > I figured I should keep linux-wireless@ in the loop.)
> > 
> > Willing to bash on whatever I need to to improve this.
> 
> Sounds like the issue here:
> 
> 	https://bugzilla.redhat.com/show_bug.cgi?id=441819
> 
> Perhaps you could post some iwevent info as Dan requested there as well?

Yeah, could be an NM issue or a supplicant issue I guess.  Or, even if
the card _is_ returning scan results, it might not be returning results
for your AP.

Do you have hardware or software scanning on (ie, is disable_hw_scan
module option 1 or 0?)

dan

