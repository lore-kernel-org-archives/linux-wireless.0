Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39246 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932079AbbI1Rms (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2015 13:42:48 -0400
Message-ID: <1443462165.2401.7.camel@sipsolutions.net> (sfid-20150928_194251_442018_CC7C4CB4)
Subject: Re: [wireless-regdb] wireless-regdb: Update regulatory rules for
 South Africa (ZA) on 5GHz
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>,
	Karl =?ISO-8859-1?Q?M=F6ller?= <karl@excors.net>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Date: Mon, 28 Sep 2015 19:42:45 +0200
In-Reply-To: <20150928160741.GA25936@ubuntu-hedt> (sfid-20150928_180803_494069_1D6E674B)
References: <9BEBB87E-EA6D-4219-ADC5-40C1E19DA5DA@excors.net>
	 <1443426260.2401.2.camel@sipsolutions.net>
	 <20150928160741.GA25936@ubuntu-hedt> (sfid-20150928_180803_494069_1D6E674B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-09-28 at 11:07 -0500, Seth Forshee wrote:
> On Mon, Sep 28, 2015 at 09:44:20AM +0200, Johannes Berg wrote:
> > 
> > > The bands don’t quite match up and DFS/TPC is (apparently) not 
> > > required for 5470 - 5725. More importantly, the max transmitted 
> > > power
> > > seems to be 1W/30dBm e.i.r.p and not 27dBm.
> > 
> > Without checking now, just a note: we sometimes have lower limits 
> > here
> > due to spectral power density, indoor/outdoor or TPC requirements.
> 
> One of the documents says that the TPC requirement for that range was
> lifted in March 2015, so if it was lowered for TPC then we may be 
> able to bump it up to 30 dBm.
> 

That's very well possible then - the typical TCP requirement is "1/2 of
the power w/o TPC", which would match the 3dB

johannes
